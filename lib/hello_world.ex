defmodule HelloWorld do
  def parse_command(head, line, acc, max_line) do
    case String.split(head, " ") do
      ["add", num] ->
        {line + 1, acc + String.to_integer(num)}

      ["cmp", num, line_num] ->
        cond do
          acc == String.to_integer(num) ->
            if String.to_integer(line_num) > max_line do
              IO.puts("Line number out of range")
            else
              {String.to_integer(line_num), acc}
            end

          acc != String.to_integer(num) ->
            {line + 1, acc}
        end

      ["input"] ->
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
        IO.puts(" :( Unknown command: #{head}, line: #{line} )")
        {line + 1, acc}
    end
  end

  def run(program, line, acc) do
    if line >= tuple_size(program) do
      IO.puts(":( Script ended on line: #{line} )")
      acc
    else
      case parse_command(elem(program, line), line, acc, tuple_size(program)) do
        {:end, acc} ->
          IO.puts(":( Script ended on line: #{line} )")
          acc

        {line, acc} ->
          run(program, line, acc)
      end
    end
  end

  def main() do
    code =
      "puts Enter Password:\ninput\ncmp 7331 5\nputs Wrong Password\nend\nadd 10\nputs GoodBoy"

    program = code |> String.split("\n") |> List.to_tuple()
    run(program, 0, 0)
  end
end
