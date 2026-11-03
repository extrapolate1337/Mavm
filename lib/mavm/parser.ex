defmodule Mavm.Parser do
  def parse(line) do
    case String.split(line, " ") do
      ["cmp", num, lnum] -> {:cmp, String.to_integer(num), String.to_integer(lnum)}
      ["jge", num, lnum] -> {:jge, String.to_integer(num), String.to_integer(lnum)}
      ["jle", num, lnum] -> {:jle, String.to_integer(num), String.to_integer(lnum)}
      ["jmp", lnum] -> {:jmp, String.to_integer(lnum)}
      ["grow", len] -> {:grow, String.to_integer(len)}
      ["get", idx] -> {:get, String.to_integer(idx)}
      ["set", idx] -> {:set, String.to_integer(idx)}
      ["ldx", addr] -> {:ldx, String.to_integer(addr)}
      ["stx", addr] -> {:stx, String.to_integer(addr)}
      ["sex", addr] -> {:stx, String.to_integer(addr)}
      ["seta", num] -> {:seta, String.to_integer(num)}
      ["add", num] -> {:add, String.to_integer(num)}
      ["sub", num] -> {:sub, String.to_integer(num)}
      ["mul", num] -> {:mul, String.to_integer(num)}
      ["div", num] -> {:div, String.to_integer(num)}
      ["mod", num] -> {:mod, String.to_integer(num)}
      ["inc"] -> :inc
      ["dec"] -> :dec
      ["neg"] -> :neg
      ["abs"] -> :abs
      ["read"] -> :read
      ["puti"] -> :puti
      ["puts" | string] -> {:puts, Enum.join(string, " ")}
      ["end"] -> :end
      _ -> {:unknown, line}
    end
  end
end
