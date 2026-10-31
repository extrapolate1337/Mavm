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
| `cmp N L` | if `acc == N`, jump to line `L` |
| `jge N L` | if `acc >= N`, jump to line `L` |
| `jle N L` | if `acc <= N`, jump to line `L` |
| `jmp L` | jump to line `L` |
| `end` | terminate the program |

### Memory

| Command | Description |
|---|---|
| `get I` | `acc = mem[I]` |
| `set I` | `mem[I] = acc` |
| `loadx A` | `acc = mem[mem[A]]` (indirect read) |
| `storex A` | `mem[mem[A]] = acc` (indirect write) |
| `grow N` | append `N` zero cells to memory |

### I/O

| Command | Description |
|---|---|
| `read` | read a number from stdin into `acc` |
| `puti` | print `acc` |
| `puts TEXT` | print text |

## Line numbering

Instructions are numbered from **0**. The first line of the script is line `0`.

## Run

```bash
mix run -- <script-file>
