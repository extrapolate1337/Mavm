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

| Command | Description |
|---|---|
| `seta N` | `acc = N` |
| `add N` | `acc = acc + N` |
| `addm A` | `acc = acc + mem[mem[A]]` (indirect memory add) |
| `sub N` | `acc = acc - N` |
| `mul N` | `acc = acc * N` |
| `div N` | `acc = acc / N` (integer division) |
| `mod N` | `acc = acc % N` |
| `inc` | `acc = acc + 1` |
| `dec` | `acc = acc - 1` |
| `neg` | `acc = -acc` |
| `abs` | `acc = abs(acc)` |

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

Jump targets are validated: if `L < 0` or `L >= max_line`, the program halts
with an error message.

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
