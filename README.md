<div align="center">

# 🧮 MAVM

**M**ini **A**ccumulator **V**irtual **M**achine

*A tiny educational interpreter in Elixir — one register, 64 memory cells, no dependencies.*

[![Language](https://img.shields.io/badge/language-Elixir-4B275F?logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Build](https://img.shields.io/badge/build-mix-6E4A7E?logo=elixir&logoColor=white)](https://hexdocs.pm/mix/Mix.html)
[![Stars](https://img.shields.io/github/stars/extrapolate1337/Mavm?style=social)](https://github.com/extrapolate1337/Mavm)

</div>

MAVM is a small accumulator-based VM and an interpreter for an assembly-like language.
The parser turns each line into an instruction tuple; the executor updates three values:
`acc` (the only register), `line` (program counter), and `mem` (64 cells by default).

## 🚀 Quick Start

Requires **Elixir 1.20+**.

```bash
git clone https://github.com/extrapolate1337/Mavm.git
cd Mavm

mix run -- examples/countdown
printf '10\n' | mix run -- examples/fibonacci
```

A program is read from the file passed as the first argument. Instructions are numbered from
`0`; blank lines and comments (`# ...`) are skipped before numbering.

## 📜 Instructions

### Arithmetic

| Command | Effect |
|---|---|
| `seta N` | `acc = N` |
| `add N` / `sub N` / `mul N` | `acc += N`, `acc -= N`, `acc *= N` |
| `div N` / `mod N` | integer division / remainder |
| `inc` / `dec` / `neg` / `abs` | `+1` / `-1` / negate / absolute value |

### Memory

| Command | Effect |
|---|---|
| `get I` / `set I` | direct read / write at `mem[I]` |
| `ldx A` / `stx A` | indirect read / write through `mem[A]` |
| `sex A` | alias for `stx` |
| `grow N` | append `N` zero cells (`N >= 2`) |
| `addm A` / `subm A` / `mulm A` | arithmetic with `mem[A]` |
| `divm A` / `modm A` | division / remainder by `mem[A]` |

### Bitwise

| Command | Effect |
|---|---|
| `shl N` / `shr N` | shift left / arithmetic shift right |
| `shlm A` / `shrm A` | same, with shift amount from `mem[A]` |

### Control Flow

| Command | Effect |
|---|---|
| `je N L` / `jne N L` | jump if `acc == N` / `acc != N` |
| `jge N L` / `jle N L` | jump if `acc >= N` / `acc <= N` |
| `jg N L` / `jl N L` | jump if `acc > N` / `acc < N` |
| `jmp L` | unconditional jump |
| `end` | halt the program |

### I/O

| Command | Effect |
|---|---|
| `read` | read an integer from stdin into `acc` |
| `puti` | print `acc` |
| `puts TEXT` | print text |

## 🎬 Example

```text
puts Countdown:
add 5
puti
dec
je 0 6
jmp 2
end
```

```text
$ mix run -- examples/countdown
Countdown:
5
4
3
2
1
```

More programs live in [`examples/`](examples): a calculator, password check, Fibonacci, and
indirect memory addressing.

## ⚠️ Notes

- Memory indices and jump targets are bounds-checked; invalid accesses halt the VM.
- `div 0` and negative shift amounts halt with an error.
- Unknown commands print a warning and execution continues.
- `examples/array` uses obsolete `loadx`/`storex`; use `ldx`/`stx`.

## 🛠️ Development

```bash
mix compile
mix format
```
