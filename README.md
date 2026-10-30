# MAVM

A mini-interpreter for a custom scripting language written in Elixir.

## What it is

A small educational **Mini Accumulator VM** with a single register.

## Commands

| Command | Description |
|---|---|
| `add N` | `acc = acc + N` |
| `cmp N L` | if `acc == N`, jump to line `L` |
| `jge N L` | if `acc >= N`, jump to line `L` |
| `jle N L` | if `acc <= N`, jump to line `L` |
| `jmp L` | jump to line `L` |
| `read` | read a number into `acc` |
| `put` | print `acc` |
| `puts TEXT` | print text |
| `end` | terminate the program |

## Run

```bash
mix run -- <script-file>
