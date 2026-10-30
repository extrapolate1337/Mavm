defmodule Mavm do
  def parse_command(head, line, acc, max_line) do
    case String.split(head, " ") do
      ["add", num] ->
        {line + 1, acc + String.to_integer(num)}

      ["cmp", num, line_num] ->
        if acc == String.to_integer(num) do
          if String.to_integer(line_num) > max_line || String.to_integer(line_num) < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc}
          else
            {String.to_integer(line_num), acc}
          end
        else
          {line + 1, acc}
        end

      ["jge", num, line_num] ->
        if acc >= String.to_integer(num) do
          if String.to_integer(line_num) > max_line || String.to_integer(line_num) < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc}
          else
            {String.to_integer(line_num), acc}
          end
        else
          {line + 1, acc}
        end

      ["jle", num, line_num] ->
        if acc <= String.to_integer(num) do
          if String.to_integer(line_num) > max_line || String.to_integer(line_num) < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc}
          else
            {String.to_integer(line_num), acc}
          end
        else
          {line + 1, acc}
        end

      ["jmp", line_num] ->
        {String.to_integer(line_num), acc}

      ["read"] ->
        {line + 1, String.to_integer(String.trim(IO.gets("")))}

      ["put"] ->
        IO.puts(acc)
        {line + 1, acc}

      ["puts" | string] ->
        IO.puts(Enum.join(string, " "))
        {line + 1, acc}

      ["end"] ->
        # {tuple_size(program), acc}
        {:end, acc}

      _ ->
        IO.puts("Unknown command: #{head}, line: #{line}")
        {line + 1, acc}
    end
  end

  def run(program, line, acc) do
    if line >= tuple_size(program) do
      # IO.puts(":( Script ended on line: #{line} )")
      acc
    else
      case parse_command(elem(program, line), line, acc, tuple_size(program)) do
        {:end, acc} ->
          # IO.puts(":( Script ended on line: #{line} )")
          acc

        {line, acc} ->
          run(program, line, acc)
      end
    end
  end

  def main do
    case System.argv() do
      [path] ->
        code = File.read!(path)
        program = code |> String.split("\n") |> List.to_tuple()
        run(program, 0, 0)

      _ ->
        IO.puts("Usage: mix run -- <script-file>")
    end
  end
end
