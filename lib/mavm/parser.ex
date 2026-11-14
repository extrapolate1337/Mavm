defmodule Mavm.Parser do
  def parse(line) do
    case String.split(line, " ") do
      # Control flow
      ["je", num, lnum] -> {:je, String.to_integer(num), String.to_integer(lnum)}
      ["jne", num, lnum] -> {:jne, String.to_integer(num), String.to_integer(lnum)}
      ["jge", num, lnum] -> {:jge, String.to_integer(num), String.to_integer(lnum)}
      ["jle", num, lnum] -> {:jle, String.to_integer(num), String.to_integer(lnum)}
      ["jg", num, lnum] -> {:jg, String.to_integer(num), String.to_integer(lnum)}
      ["jl", num, lnum] -> {:jl, String.to_integer(num), String.to_integer(lnum)}
      ["jmp", lnum] -> {:jmp, String.to_integer(lnum)}
      ["call", lnum] -> {:call, String.to_integer(lnum)}
      ["ret"] -> :ret
      ["end"] -> :end
      # Memory
      ["grow", len] -> {:grow, String.to_integer(len)}
      ["get", idx] -> {:get, String.to_integer(idx)}
      ["set", idx] -> {:set, String.to_integer(idx)}
      ["ldx", addr] -> {:ldx, String.to_integer(addr)}
      ["stx", addr] -> {:stx, String.to_integer(addr)}
      ["sex", addr] -> {:stx, String.to_integer(addr)}
      # Bitwise
      ["shl", num] -> {:shl, String.to_integer(num)}
      ["shr", num] -> {:shr, String.to_integer(num)}
      ["shlm", addr] -> {:shlm, String.to_integer(addr)}
      ["shrm", addr] -> {:shrm, String.to_integer(addr)}
      # Arithmetic
      ["seta", num] -> {:seta, String.to_integer(num)}
      ["add", num] -> {:add, String.to_integer(num)}
      ["addm", addr] -> {:addm, String.to_integer(addr)}
      ["sub", num] -> {:sub, String.to_integer(num)}
      ["subm", addr] -> {:subm, String.to_integer(addr)}
      ["mul", num] -> {:mul, String.to_integer(num)}
      ["mulm", addr] -> {:mulm, String.to_integer(addr)}
      ["div", num] -> {:div, String.to_integer(num)}
      ["divm", addr] -> {:divm, String.to_integer(addr)}
      ["mod", num] -> {:mod, String.to_integer(num)}
      ["modm", addr] -> {:modm, String.to_integer(addr)}
      ["inc"] -> :inc
      ["dec"] -> :dec
      ["neg"] -> :neg
      ["abs"] -> :abs
      # I/O
      ["read"] -> :read
      ["puti"] -> :puti
      ["puts" | string] -> {:puts, Enum.join(string, " ")}
      _ -> {:unknown, line}
    end
  end
end
