<div align="center">

# 🧮 MAVM

**M**ini **A**ccumulator **V**irtual **M**achine

*A tiny educational interpreter in Elixir — one register.*

[![Language](https://img.shields.io/badge/language-Elixir-4B275F?logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Build](https://img.shields.io/badge/build-mix-6E4A7E?logo=elixir&logoColor=white)](https://hexdocs.pm/mix/Mix.html)
[![Stars](https://img.shields.io/github/stars/extrapolate1337/Mavm?style=social)](https://github.com/extrapolate1337/Mavm)

</div>

MAVM is a small accumulator-based VM and an interpreter for an assembly-like language.
The parser turns each line into an instruction tuple; the executor updates three values:
`acc` (the only register), `line` (program counter), and `mem` (128 cells by default).
Programs can also be split across files: **a file is a function**.

## 🚀 Quick Start

Requires **Elixir 1.20+**.

```bash
git clone https://github.com/extrapolate1337/Mavm.git
cd Mavm

mix run -- examples/countdown
printf '20\n' | mix run -- examples/fibonacci.mavm
```

A program is read from the file passed as the first argument. Instructions are numbered from
`0`; blank lines and comments (`# ...`) are skipped before numbering.

## 📜 Instruction Set

Commands and arguments are separated by spaces. `N` and `I` are integer literals, `A` is a
memory index.

### ➕ Arithmetic

| Command | Effect |
|---|---|
| `seta N` | `acc = N` |
| `add N` | `acc = acc + N` |
| `sub N` | `acc = acc - N` |
| `mul N` | `acc = acc * N` |
| `div N` | `acc = acc div N` — integer division |
| `mod N` | `acc = acc rem N` — remainder |
| `inc` | `acc = acc + 1` |
| `dec` | `acc = acc - 1` |
| `neg` | `acc = -acc` |
| `abs` | `acc = abs(acc)` |

### 🧮 Memory Arithmetic

The right-hand operand comes from memory. `A` is a direct address; use `ldx`/`stx` for
indirection.

| Command | Effect |
|---|---|
| `addm A` | `acc = acc + mem[A]` |
| `subm A` | `acc = acc - mem[A]` |
| `mulm A` | `acc = acc * mem[A]` |
| `divm A` | `acc = acc div mem[A]` — halts on zero |
| `modm A` | `acc = acc rem mem[A]` — halts on zero |

### 🔢 Bitwise Operations

`shr` is an arithmetic right shift: the sign is preserved.

| Command | Effect |
|---|---|
| `shl N` | `acc = acc <<< N` |
| `shr N` | `acc = acc >>> N` |
| `shlm A` | `acc = acc <<< mem[A]` |
| `shrm A` | `acc = acc >>> mem[A]` |

### 💾 Memory

| Command | Effect |
|---|---|
| `get I` | `acc = mem[I]` |
| `set I` | `mem[I] = acc` |
| `ldx A` | `acc = mem[mem[A]]` |
| `stx A` | `mem[mem[A]] = acc` |
| `sex A` | alias for `stx` |
| `grow N` | append `N` zero cells (`N >= 2`) |

### 🔀 Control Flow

| Command | Effect |
|---|---|
| `je N L` | jump to `L` if `acc == N` |
| `jne N L` | jump to `L` if `acc != N` |
| `jge N L` | jump to `L` if `acc >= N` |
| `jle N L` | jump to `L` if `acc <= N` |
| `jg N L` | jump to `L` if `acc > N` |
| `jl N L` | jump to `L` if `acc < N` |
| `jmp L` | unconditional jump to `L` |
| `end` | terminate the program |

### 🧵 Subroutines
| Command | Effect |
|---|---|
| `call L`	| push `line + 1` onto `ret_stack`, jump to `L` — local call by line number |
| `callf P`	| execute the file at `PATH` as a function (see below) |
| `ret`	| pop the top of `ret_stack` and jump there; if the stack is empty, return `acc` from the current `callf` file |

### 🖨️ I/O

| Command | Effect |
|---|---|
| `geti` | read an integer from stdin into `acc` |
| `puti` | print `acc` |
| `getc` | read one character from stdin; `acc` = its Unicode codepoint |
| `putc` | print `acc` as a Unicode character |
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

## 🛠️ Development

```bash
mix compile
mix format
```
