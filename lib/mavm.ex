defmodule Mavm do
  alias Mavm.{Executor, Parser}

  def run(program, line, acc, mem) do
    if line >= tuple_size(program) do
      acc
    else
      case Executor.execute(elem(program, line), line, acc, mem, tuple_size(program)) do
        {:end, acc, mem} -> acc
        {line, acc, mem} -> run(program, line, acc, mem)
      end
    end
  end

  def main do
    case System.argv() do
      [path] ->
        program =
          path
          |> File.read!()
          |> String.split("\n", trim: true)
          |> Enum.reject(&String.starts_with?(String.trim(&1), "#"))
          |> Enum.map(&Parser.parse/1)
          |> List.to_tuple()

        run(program, 0, 0, List.to_tuple(List.duplicate(0, 64)))

      _ ->
        IO.puts("Usage: mix run -- <script-file>")
    end
  end
end
