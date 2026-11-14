# MAVM

A mini-interpreter for a custom scripting language written in Elixir.

## What it is

A small educational **Mini Accumulator VM** with a single register (`acc`),
a program counter (`line`), and a fixed-size memory (`mem`).

- `acc` — the only working register (all arithmetic goes through it)
- `line` — index of the current instruction
- `mem` — tuple of cells, 64 by default, indexed from `0`

## Commands

### Arithmetic

All immediate-operand arithmetic. `N` is a literal integer baked into the
instruction.

| Command | Description |
|---|---|
| `seta N` | `acc = N` |
| `add N` | `acc = acc + N` |
| `sub N` | `acc = acc - N` |
| `mul N` | `acc = acc * N` |
| `div N` | `acc = acc div N` (integer division) |
| `mod N` | `acc = acc rem N` |
| `inc` | `acc = acc + 1` |
| `dec` | `acc = acc - 1` |
| `neg` | `acc = -acc` |
| `abs` | `acc = abs(acc)` |

### Memory arithmetic

Same operations, but the right-hand operand is read from memory:
`acc = acc <op> mem[A]`. `A` is a **direct** memory index (not indirect —
use `ldx`/`stx` if you need one level of indirection).

| Command | Description |
|---|---|
| `addm A` | `acc = acc + mem[A]` |
| `subm A` | `acc = acc - mem[A]` |
| `mulm A` | `acc = acc * mem[A]` |
| `divm A` | `acc = acc div mem[A]` — halts if `mem[A] == 0` |
| `modm A` | `acc = acc rem mem[A]` — halts if `mem[A] == 0` |

`divm` and `modm` perform a **runtime** zero-divisor check (the divisor
is only known at execution time, unlike `div 0` / `mod 0`, which the
parser can reject statically).

### Bitwise

Bit shifts. `acc` is treated as a signed integer; `shr` is an
**arithmetic** right shift (sign is preserved, e.g. `-8 shr 1 == -4`).

| Command | Description |
|---|---|
| `shl N` | `acc = acc <<< N` (shift left) |
| `shr N` | `acc = acc >>> N` (arithmetic shift right) |
| `shlm A` | `acc = acc <<< mem[A]` (shift left by memory value) |
| `shrm A` | `acc = acc >>> mem[A]` (shift right by memory value) |

Shift amount must be **non-negative**; a negative amount halts the VM
with an error (Elixir raises `ArithmeticError` on `n <<< -k`).

### Memory

| Command | Description |
|---|---|
| `get I` | `acc = mem[I]` (direct read) |
| `set I` | `mem[I] = acc` (direct write) |
| `ldx A` | `acc = mem[mem[A]]` (indirect read) |
| `stx A` | `mem[mem[A]] = acc` (indirect write) |
| `sex A` | alias for `stx` (see *Known issues*) |
| `grow N` | append `N` zero cells to memory; `N` must be `>= 2` |

All memory indices are bounds-checked. An out-of-range index (or an
out-of-range target inside an indirect access) halts the VM with an error.

### Control flow

| Command | Description |
|---|---|
| `je N L` | if `acc == N`, jump to line `L`, else continue to next line |
| `jne N L` | if `acc != N`, jump to line `L`, else continue to next line |
| `jge N L` | if `acc >= N`, jump to line `L`, else continue to next line |
| `jle N L` | if `acc <= N`, jump to line `L`, else continue to next line |
| `jg N L` | if `acc > N`, jump to line `L`, else continue to next line |
| `jl N L` | if `acc < N`, jump to line `L`, else continue to next line |
| `jmp L` | unconditional jump to line `L` |
| `end` | terminate the program |

Jump targets are validated: if `L < 0` or `L >= max_line`, the program
halts with an error message.

### I/O

| Command | Description |
|---|---|
| `read` | read a line from stdin and parse it as an integer into `acc` |
| `puti` | print `acc` to stdout |
| `puts TEXT` | print `TEXT` (all remaining tokens, joined by a single space) |

## Line numbering

Instructions are numbered from **0**. The first line of the script is line `0`.

## Run

```bash
mix run -- <script-file>
