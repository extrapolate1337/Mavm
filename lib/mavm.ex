defmodule Mavm do
  def parse_command(head, line, acc, mem, max_line) do
    case String.split(head, " ") do
      ["cmp", num, line_num] ->
        line_num = String.to_integer(line_num)

        if acc == String.to_integer(num) do
          if line_num >= max_line || line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      ["jge", num, line_num] ->
        line_num = String.to_integer(line_num)

        if acc >= String.to_integer(num) do
          if line_num >= max_line || line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      ["jle", num, line_num] ->
        line_num = String.to_integer(line_num)

        if acc <= String.to_integer(num) do
          if line_num >= max_line || line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      ["jmp", line_num] ->
        line_num = String.to_integer(line_num)

        if line_num >= max_line do
          IO.puts("Line number out of range. Line: #{line}")
          {:end, acc, mem}
        else
          {line_num, acc, mem}
        end

      ["grow", len] ->
        len = String.to_integer(len)

        if len < 2 do
          IO.puts("Grow size must be at least 2, got #{len}. Line: #{line}")
          {:end, acc, mem}
        else
          new_mem = List.to_tuple(Tuple.to_list(mem) ++ List.duplicate(0, len))
          {line + 1, acc, new_mem}
        end

      ["get", idx] ->
        idx = String.to_integer(idx)

        if idx >= tuple_size(mem) || idx < 0 do
          IO.puts("Memory index out of range. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, elem(mem, idx), mem}
        end

      ["set", idx] ->
        idx = String.to_integer(idx)

        if idx >= tuple_size(mem) || idx < 0 do
          IO.puts("Memory index out of range. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc, put_elem(mem, idx, acc)}
        end

      ["loadx", addr] ->
        addr = String.to_integer(addr)

        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Loadx address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          target = elem(mem, addr)

          if target < 0 or target >= tuple_size(mem) do
            IO.puts("Loadx target index out of range: #{target}. Line: #{line}")
            {:end, acc, mem}
          else
            {line + 1, elem(mem, target), mem}
          end
        end

      ["storex", addr] ->
        addr = String.to_integer(addr)

        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Storex address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          target = elem(mem, addr)

          if target < 0 or target >= tuple_size(mem) do
            IO.puts("Storex target index out of range: #{target}. Line: #{line}")
            {:end, acc, mem}
          else
            {line + 1, acc, put_elem(mem, target, acc)}
          end
        end

      ["seta", num] ->
        {line + 1, String.to_integer(num), mem}

      ["add", num] ->
        {line + 1, acc + String.to_integer(num), mem}

      ["sub", num] ->
        {line + 1, acc - String.to_integer(num), mem}

      ["inc"] ->
        {line + 1, acc + 1, mem}

      ["dec"] ->
        {line + 1, acc - 1, mem}

      ["mul", num] ->
        {line + 1, acc * String.to_integer(num), mem}

      ["div", num] ->
        {line + 1, div(acc, String.to_integer(num)), mem}

      ["mod", num] ->
        num = String.to_integer(num)

        if num == 0 do
          IO.puts("Mod division by zero. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, rem(acc, num), mem}
        end

      ["neg"] ->
        {line + 1, -acc, mem}

      ["abs"] ->
        {line + 1, abs(acc), mem}

      ["read"] ->
        {line + 1, String.to_integer(String.trim(IO.gets(""))), mem}

      ["puti"] ->
        IO.puts(acc)
        {line + 1, acc, mem}

      ["puts" | string] ->
        IO.puts(Enum.join(string, " "))
        {line + 1, acc, mem}

      ["end"] ->
        # {tuple_size(program), acc}
        {:end, acc, mem}

      _ ->
        IO.puts("Unknown command: #{head}, line: #{line}")
        {line + 1, acc, mem}
    end
  end

  def run(program, line, acc, mem) do
    if line >= tuple_size(program) do
      # IO.puts(":( Script ended on line: #{line} )")
      acc
    else
      case parse_command(elem(program, line), line, acc, mem, tuple_size(program)) do
        {:end, acc, mem} ->
          # IO.puts(":( Script ended on line: #{line} )")
          acc

        {line, acc, mem} ->
          run(program, line, acc, mem)
      end
    end
  end

  def main do
    case System.argv() do
      [path] ->
        code = File.read!(path)
        program = code |> String.split("\n", trim: true) |> List.to_tuple()
        run(program, 0, 0, List.to_tuple(List.duplicate(0, 64)))

      _ ->
        IO.puts("Usage: mix run -- <script-file>")
    end
  end
end
