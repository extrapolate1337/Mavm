defmodule Mavm do
  alias Mavm.{Executor, Parser}
  @mem_size 128

  def run(program, line, acc, mem, ret_stack) do
    if line >= tuple_size(program) do
      {acc, mem, ret_stack}
    else
      case Executor.execute(elem(program, line), line, acc, mem, tuple_size(program), ret_stack) do
        {:end, acc, mem, ret_stack} ->
          {:end, acc, mem, ret_stack}

        {:ret, acc, mem, ret_stack} ->
          {:ret, acc, mem, ret_stack}

        {:callf, path, next_line, acc, mem, ret_stack} ->
          sub_program = Parser.parse_file(path)

          case run(sub_program, 0, acc, mem, []) do
            {:ret, sub_acc, sub_mem, _} -> run(program, next_line, sub_acc, sub_mem, ret_stack)
            {:end, _, sub_mem, _} -> run(program, next_line, acc, sub_mem, ret_stack)
          end

        {next_line, acc, mem, ret_stack} ->
          run(program, next_line, acc, mem, ret_stack)
      end
    end
  end

  def main do
    case System.argv() do
      [path] ->
        program = Parser.parse_file(path)

        {kind, acc, _, _} =
          run(program, 0, 0, List.to_tuple(List.duplicate(0, @mem_size)), [])

        case kind do
          :ret -> IO.puts("\nReturned: #{acc}")
          :end -> IO.puts("\nDone, acc=#{acc}")
        end

      _ ->
        IO.puts("Usage: mix run -- <script-file>")
    end
  end
end
