#!/usr/bin/env python3
"""Random RV32IM program generator for the co-simulation testbench.

Every program terminates (forward branches, counted loops, leaf calls only) and
only touches a small data area, so stores and loads alias all the time.

usage: gen_random.py <seed> <out.S> [number of blocks] [profile]
profiles: mix (default), alu, mem, branch, muldiv
"""
import random
import sys

RESERVED = {0, 1, 5, 27, 28, 29, 30, 31}   # x1/x5: link, x27-x29: loop counters, x30: data base, x31: address scratch
FREE = [r for r in range(32) if r not in RESERVED]

ALU_RR = ["add", "sub", "sll", "slt", "sltu", "xor", "srl", "sra", "or", "and"]
ALU_RI = ["addi", "slti", "sltiu", "xori", "ori", "andi"]
SHIFT_I = ["slli", "srli", "srai"]
MULDIV = ["mul", "mulh", "mulhsu", "mulhu", "div", "divu", "rem", "remu"]
BRANCH = ["beq", "bne", "blt", "bge", "bltu", "bgeu"]
LOADS = [("lw", 4), ("lh", 2), ("lhu", 2), ("lb", 1), ("lbu", 1)]
STORES = [("sw", 4), ("sh", 2), ("sb", 1)]
SPECIAL = [0, 1, -1, 2, -2, 0x7FFFFFFF, -0x80000000, 0x55555555, -0x55555556, 0xFFFF, 0x10000, 31, 32, 255, -256]
DATA_BYTES = 64   # stores/loads stay inside this area


class Gen:
    def __init__(self, seed, profile):
        self.r = random.Random(seed)
        self.profile = profile
        self.lines = []
        self.label = 0
        self.funcs = 0
        self.depth = 0      # loop nesting, selects the counter register (x27, x28 in main code)
        self.max_depth = 2
        self.nest = 0

    def emit(self, s):
        self.lines.append("    " + s)

    def lab(self):
        self.label += 1
        return f"L{self.label}"

    def place(self, l):
        self.lines.append(f"{l}:")

    def src(self):
        # recently written registers are used more often (dependency chains)
        return self.r.choice(FREE + [0, 0, 1, 5] + self.recent[-4:] * 3) if self.recent else self.r.choice(FREE)

    def dst(self):
        d = self.r.choice(FREE + [0])
        if d:
            self.recent.append(d)
        return d

    def imm12(self):
        if self.r.random() < 0.3:
            return self.r.choice([0, 1, -1, 2047, -2048, 4, 8, 31, 255])
        return self.r.randint(-2048, 2047)

    # ---------------------------------------------------------------- blocks
    def alu(self):
        k = self.r.random()
        if k < 0.40:
            self.emit(f"{self.r.choice(ALU_RR)} x{self.dst()}, x{self.src()}, x{self.src()}")
        elif k < 0.70:
            self.emit(f"{self.r.choice(ALU_RI)} x{self.dst()}, x{self.src()}, {self.imm12()}")
        elif k < 0.82:
            self.emit(f"{self.r.choice(SHIFT_I)} x{self.dst()}, x{self.src()}, {self.r.randint(0, 31)}")
        elif k < 0.90:
            self.emit(f"lui x{self.dst()}, {self.r.randint(0, 0xFFFFF)}")
        elif k < 0.95:
            self.emit(f"auipc x{self.dst()}, {self.r.randint(0, 0xFFFFF)}")
        else:
            self.emit(f"li x{self.dst()}, {self.r.choice(SPECIAL)}")

    def muldiv(self):
        if self.r.random() < 0.4:
            # special operands: division by zero, overflow, signs
            a, b = self.r.choice(FREE), self.r.choice(FREE)
            self.emit(f"li x{a}, {self.r.choice(SPECIAL)}")
            self.emit(f"li x{b}, {self.r.choice(SPECIAL)}")
            self.emit(f"{self.r.choice(MULDIV)} x{self.dst()}, x{a}, x{b}")
        else:
            self.emit(f"{self.r.choice(MULDIV)} x{self.dst()}, x{self.src()}, x{self.src()}")

    def chain(self):
        # back to back dependent instructions (forwarding / wakeup)
        d = self.r.choice(FREE)
        self.recent.append(d)
        for _ in range(self.r.randint(2, 6)):
            k = self.r.random()
            if k < 0.6:
                self.emit(f"{self.r.choice(ALU_RI)} x{d}, x{d}, {self.imm12()}")
            elif k < 0.9:
                self.emit(f"{self.r.choice(ALU_RR)} x{d}, x{d}, x{self.src()}")
            else:
                self.emit(f"{self.r.choice(MULDIV)} x{d}, x{d}, x{self.src()}")

    def mem_fixed(self):
        n = self.r.randint(1, 4)
        for _ in range(n):
            if self.r.random() < 0.5:
                op, sz = self.r.choice(STORES)
                off = self.r.randrange(0, DATA_BYTES, sz)
                self.emit(f"{op} x{self.src()}, {off}(x30)")
            else:
                op, sz = self.r.choice(LOADS)
                off = self.r.randrange(0, DATA_BYTES, sz)
                self.emit(f"{op} x{self.dst()}, {off}(x30)")

    def mem_computed(self):
        # address depends on a register (often a slow one), followed by loads which may alias it
        a = self.src()
        if self.r.random() < 0.4:
            t = self.r.choice(FREE)
            self.emit(f"{self.r.choice(['div', 'mul', 'remu', 'divu'])} x{t}, x{a}, x{self.src()}")
            a = t
        op, sz = self.r.choice(STORES + LOADS)
        mask = (DATA_BYTES - 1) & ~(sz - 1)
        self.emit(f"andi x31, x{a}, {mask}")
        self.emit("add x31, x31, x30")
        if op.startswith("s"):
            self.emit(f"{op} x{self.src()}, 0(x31)")
        else:
            self.emit(f"{op} x{self.dst()}, 0(x31)")
        for _ in range(self.r.randint(0, 3)):
            lop, lsz = self.r.choice(LOADS)
            self.emit(f"{lop} x{self.dst()}, {self.r.randrange(0, DATA_BYTES, lsz)}(x30)")

    def fwd_branch(self):
        l = self.lab()
        self.emit(f"{self.r.choice(BRANCH)} x{self.src()}, x{self.src()}, {l}")
        if self.r.random() < 0.25:
            # two branches in one bundle
            l2 = self.lab()
            self.emit(f"{self.r.choice(BRANCH)} x{self.src()}, x{self.src()}, {l2}")
            self.body(self.r.randint(0, 3))
            self.place(l2)
        self.body(self.r.randint(1, 5))
        self.place(l)

    def loop(self):
        if self.depth >= self.max_depth:
            return self.alu()
        cnt = 27 + self.depth
        self.depth += 1
        l = self.lab()
        self.emit(f"li x{cnt}, {self.r.randint(1, 6)}")
        self.place(l)
        self.body(self.r.randint(1, 6))
        self.emit(f"addi x{cnt}, x{cnt}, -1")
        self.emit(f"bnez x{cnt}, {l}")
        self.depth -= 1

    def jump(self):
        l = self.lab()
        k = self.r.random()
        if k < 0.4:
            self.emit(f"jal x{self.r.choice([0, 0] + FREE)}, {l}")
        elif k < 0.7:
            self.emit(f"la x31, {l}")
            self.emit(f"jalr x{self.r.choice([0, 0] + FREE)}, 0(x31)")
        elif k < 0.85:
            off = self.r.choice([-2044, -16, -4, 4, 12, 2044])
            self.emit(f"la x31, {l}")
            self.emit(f"addi x31, x31, {-off}")
            self.emit(f"jalr x{self.r.choice([0] + FREE)}, {off}(x31)")
        else:
            # lsb of the jalr target is cleared
            self.emit(f"la x31, {l}")
            self.emit("addi x31, x31, 1")
            self.emit(f"jalr x{self.r.choice([0] + FREE)}, 0(x31)")
        self.body(self.r.randint(0, 3))   # skipped
        self.place(l)

    def call(self):
        if self.funcs == 0:
            return self.alu()
        f = self.r.randrange(self.funcs)
        k = self.r.random()
        if k < 0.5:
            self.emit(f"jal x1, func{f}")
        elif k < 0.8:
            self.emit(f"la x31, func{f}")
            self.emit("jalr x1, 0(x31)")
        else:
            self.emit(f"jal x5, func{f}_alt")

    def body(self, n):
        p = self.profile
        weights = {
            "mix":    [30, 8, 10, 14, 10, 12, 6, 5, 5],
            "alu":    [60, 5, 25, 0, 0, 5, 3, 1, 1],
            "mem":    [12, 4, 6, 34, 26, 8, 4, 3, 3],
            "branch": [15, 3, 5, 6, 4, 30, 15, 12, 10],
            "muldiv": [15, 45, 15, 5, 5, 8, 4, 2, 1],
        }[p]
        blocks = [self.alu, self.muldiv, self.chain, self.mem_fixed, self.mem_computed,
                  self.fwd_branch, self.loop, self.jump, self.call]
        if self.nest >= 3:
            # deep inside branches/loops only straight line code is generated
            weights = weights[:5] + [0, 0, 0, weights[8]]
        self.nest += 1
        for _ in range(n):
            self.r.choices(blocks, weights)[0]()
        self.nest -= 1

    def generate(self, nblocks):
        self.recent = []
        self.funcs = self.r.randint(1, 4)
        out = [
            "    .section .text.init",
            "    .globl _start",
            "_start:",
            "    la x30, data",
        ]
        self.lines = out
        for r in range(1, 30):
            if r in (27, 28, 29):
                continue
            v = self.r.choice(SPECIAL) if self.r.random() < 0.3 else self.r.randint(-2**31, 2**31 - 1)
            self.emit(f"li x{r}, {v}")
        self.body(nblocks)
        self.emit("la x31, tohost")
        self.emit("li x30, 1")
        self.emit("sw x30, 0(x31)")
        self.place("halt")
        self.emit("j halt")
        # leaf functions (x1 link: ret, x5 link: alternate return)
        # functions are called from inside loops, so their own loops use another counter (x29)
        nf, self.funcs = self.funcs, 0
        self.depth, self.max_depth = 2, 3
        for f in range(nf):
            self.place(f"func{f}")
            self.body(self.r.randint(1, 5))
            self.emit("ret")
            self.place(f"func{f}_alt")
            self.body(self.r.randint(1, 4))
            self.emit("jr x5")
        self.lines += [
            "    .section .tohost, \"aw\", @progbits",
            "    .align 3",
            "    .globl tohost",
            "tohost: .dword 0",
            "    .globl fromhost",
            "fromhost: .dword 0",
            "    .data",
            "    .align 4",
            "data:",
        ]
        for _ in range(DATA_BYTES // 4 + 4):
            self.lines.append(f"    .word 0x{self.r.getrandbits(32):08x}")
        return "\n".join(self.lines) + "\n"


if __name__ == "__main__":
    seed = int(sys.argv[1])
    nblocks = int(sys.argv[3]) if len(sys.argv) > 3 else 120
    profile = sys.argv[4] if len(sys.argv) > 4 else "mix"
    open(sys.argv[2], "w").write(Gen(seed, profile).generate(nblocks))
