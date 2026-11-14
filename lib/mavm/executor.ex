defmodule Mavm.Executor do
  import Bitwise

  def execute(head, line, acc, mem, max_line) do
    case head do
      {:je, num, line_num} ->
        if acc == num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      {:jne, num, line_num} ->
        if acc != num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      {:jge, num, line_num} ->
        if acc >= num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      {:jle, num, line_num} ->
        if acc <= num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      {:jg, num, line_num} ->
        if acc > num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      {:jl, num, line_num} ->
        if acc < num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem}
          else
            {line_num, acc, mem}
          end
        else
          {line + 1, acc, mem}
        end

      {:jmp, line_num} ->
        if line_num >= max_line or line_num < 0 do
          IO.puts("Line number out of range. Line: #{line}")
          {:end, acc, mem}
        else
          {line_num, acc, mem}
        end

      {:shl, num} ->
        if num < 0 do
          IO.puts("Shift amount must be non-negative, got #{num}. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc <<< num, mem}
        end

      {:shr, num} ->
        if num < 0 do
          IO.puts("Shift amount must be non-negative, got #{num}. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc >>> num, mem}
        end

      {:shlm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Shlm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          shift = elem(mem, addr)

          if shift < 0 do
            IO.puts(
              "Shift amount must be non-negative, got #{shift} (mem[#{addr}]). Line: #{line}"
            )

            {:end, acc, mem}
          else
            {line + 1, acc <<< shift, mem}
          end
        end

      {:shrm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Shrm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          shift = elem(mem, addr)

          if shift < 0 do
            IO.puts(
              "Shift amount must be non-negative, got #{shift} (mem[#{addr}]). Line: #{line}"
            )

            {:end, acc, mem}
          else
            {line + 1, acc >>> shift, mem}
          end
        end

      {:grow, len} ->
        if len < 2 do
          IO.puts("Grow size must be at least 2, got #{len}. Line: #{line}")
          {:end, acc, mem}
        else
          new_mem = List.to_tuple(Tuple.to_list(mem) ++ List.duplicate(0, len))
          {line + 1, acc, new_mem}
        end

      {:get, idx} ->
        if idx >= tuple_size(mem) or idx < 0 do
          IO.puts("Memory index out of range. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, elem(mem, idx), mem}
        end

      {:set, idx} ->
        if idx >= tuple_size(mem) or idx < 0 do
          IO.puts("Memory index out of range. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc, put_elem(mem, idx, acc)}
        end

      {:ldx, addr} ->
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

      {:stx, addr} ->
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

      {:seta, num} ->
        {line + 1, num, mem}

      {:add, num} ->
        {line + 1, acc + num, mem}

      {:addm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Addm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc + elem(mem, addr), mem}
        end

      {:sub, num} ->
        {line + 1, acc - num, mem}

      {:subm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Subm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc - elem(mem, addr), mem}
        end

      {:mul, num} ->
        {line + 1, acc * num, mem}

      {:mulm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Mulm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          {line + 1, acc * elem(mem, addr), mem}
        end

      {:div, 0} ->
        IO.puts("Division by zero. Line: #{line}")
        {:end, acc, mem}

      {:div, num} ->
        {line + 1, div(acc, num), mem}

      {:divm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Divm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          divisor = elem(mem, addr)

          if divisor == 0 do
            IO.puts("Division by zero (mem[#{addr}]). Line: #{line}")
            {:end, acc, mem}
          else
            {line + 1, div(acc, divisor), mem}
          end
        end

      {:mod, 0} ->
        IO.puts("Mod division by zero. Line: #{line}")
        {:end, acc, mem}

      {:mod, num} ->
        {line + 1, rem(acc, num), mem}

      {:modm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Modm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem}
        else
          divisor = elem(mem, addr)

          if divisor == 0 do
            IO.puts("Mod division by zero (mem[#{addr}]). Line: #{line}")
            {:end, acc, mem}
          else
            {line + 1, rem(acc, divisor), mem}
          end
        end

      :inc ->
        {line + 1, acc + 1, mem}

      :dec ->
        {line + 1, acc - 1, mem}

      :neg ->
        {line + 1, -acc, mem}

      :abs ->
        {line + 1, abs(acc), mem}

      :read ->
        {line + 1, String.to_integer(String.trim(IO.gets(""))), mem}

      :puti ->
        IO.puts(acc)
        {line + 1, acc, mem}

      {:puts, string} ->
        IO.puts(string)
        {line + 1, acc, mem}

      :end ->
        {:end, acc, mem}

      {:unknown, raw} ->
        IO.puts("Unknown command: #{raw}, line: #{line}")
        {line + 1, acc, mem}
    end
  end
end
