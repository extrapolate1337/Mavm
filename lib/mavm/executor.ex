defmodule Mavm.Executor do
  import Bitwise

  def execute(head, line, acc, mem, max_line, ret_stack) do
    case head do
      {:je, num, line_num} ->
        if acc == num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line_num, acc, mem, ret_stack}
          end
        else
          {line + 1, acc, mem, ret_stack}
        end

      {:jne, num, line_num} ->
        if acc != num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line_num, acc, mem, ret_stack}
          end
        else
          {line + 1, acc, mem, ret_stack}
        end

      {:jge, num, line_num} ->
        if acc >= num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line_num, acc, mem, ret_stack}
          end
        else
          {line + 1, acc, mem, ret_stack}
        end

      {:jle, num, line_num} ->
        if acc <= num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line_num, acc, mem, ret_stack}
          end
        else
          {line + 1, acc, mem, ret_stack}
        end

      {:jg, num, line_num} ->
        if acc > num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line_num, acc, mem, ret_stack}
          end
        else
          {line + 1, acc, mem, ret_stack}
        end

      {:jl, num, line_num} ->
        if acc < num do
          if line_num >= max_line or line_num < 0 do
            IO.puts("Line number out of range. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line_num, acc, mem, ret_stack}
          end
        else
          {line + 1, acc, mem, ret_stack}
        end

      {:jmp, line_num} ->
        if line_num >= max_line or line_num < 0 do
          IO.puts("Line number out of range. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line_num, acc, mem, ret_stack}
        end

      {:call, line_num} ->
        if line_num >= max_line or line_num < 0 do
          IO.puts("Line number out of range. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line_num, acc, mem, [line + 1 | ret_stack]}
        end

      {:callf, path} ->
        {:callf, path, line + 1, acc, mem, ret_stack}

      :ret ->
        case ret_stack do
          [ret_addr | rest] ->
            {ret_addr, acc, mem, rest}

          [] ->
            {:ret, acc, mem, ret_stack}
        end

      :end ->
        {:end, acc, mem, ret_stack}

      {:shl, num} ->
        if num < 0 do
          IO.puts("Shift amount must be non-negative, got #{num}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, acc <<< num, mem, ret_stack}
        end

      {:shr, num} ->
        if num < 0 do
          IO.puts("Shift amount must be non-negative, got #{num}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, acc >>> num, mem, ret_stack}
        end

      {:shlm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Shlm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          shift = elem(mem, addr)

          if shift < 0 do
            IO.puts(
              "Shift amount must be non-negative, got #{shift} (mem[#{addr}]). Line: #{line}"
            )

            {:end, acc, mem, ret_stack}
          else
            {line + 1, acc <<< shift, mem, ret_stack}
          end
        end

      {:shrm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Shrm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          shift = elem(mem, addr)

          if shift < 0 do
            IO.puts(
              "Shift amount must be non-negative, got #{shift} (mem[#{addr}]). Line: #{line}"
            )

            {:end, acc, mem, ret_stack}
          else
            {line + 1, acc >>> shift, mem, ret_stack}
          end
        end

      {:xorm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Xorm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, bxor(acc, elem(mem, addr)), mem, ret_stack}
        end

      {:xor, num} ->
        {line + 1, bxor(acc, num), mem, ret_stack}

      {:grow, len} ->
        if len < 2 do
          IO.puts("Grow size must be at least 2, got #{len}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          new_mem = List.to_tuple(Tuple.to_list(mem) ++ List.duplicate(0, len))
          {line + 1, acc, new_mem, ret_stack}
        end

      {:get, idx} ->
        if idx >= tuple_size(mem) or idx < 0 do
          IO.puts("Memory index out of range. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, elem(mem, idx), mem, ret_stack}
        end

      {:set, idx} ->
        if idx >= tuple_size(mem) or idx < 0 do
          IO.puts("Memory index out of range. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, acc, put_elem(mem, idx, acc), ret_stack}
        end

      {:ldx, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Loadx address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          target = elem(mem, addr)

          if target < 0 or target >= tuple_size(mem) do
            IO.puts("Loadx target index out of range: #{target}. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line + 1, elem(mem, target), mem, ret_stack}
          end
        end

      {:stx, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Storex address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          target = elem(mem, addr)

          if target < 0 or target >= tuple_size(mem) do
            IO.puts("Storex target index out of range: #{target}. Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line + 1, acc, put_elem(mem, target, acc), ret_stack}
          end
        end

      {:seta, num} ->
        {line + 1, num, mem, ret_stack}

      {:add, num} ->
        {line + 1, acc + num, mem, ret_stack}

      {:addm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Addm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, acc + elem(mem, addr), mem, ret_stack}
        end

      {:sub, num} ->
        {line + 1, acc - num, mem, ret_stack}

      {:subm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Subm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, acc - elem(mem, addr), mem, ret_stack}
        end

      {:mul, num} ->
        {line + 1, acc * num, mem, ret_stack}

      {:mulm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Mulm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          {line + 1, acc * elem(mem, addr), mem, ret_stack}
        end

      {:div, 0} ->
        IO.puts("Division by zero. Line: #{line}")
        {:end, acc, mem, ret_stack}

      {:div, num} ->
        {line + 1, div(acc, num), mem, ret_stack}

      {:divm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Divm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          divisor = elem(mem, addr)

          if divisor == 0 do
            IO.puts("Division by zero (mem[#{addr}]). Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line + 1, div(acc, divisor), mem, ret_stack}
          end
        end

      {:mod, 0} ->
        IO.puts("Mod division by zero. Line: #{line}")
        {:end, acc, mem, ret_stack}

      {:mod, num} ->
        {line + 1, rem(acc, num), mem, ret_stack}

      {:modm, addr} ->
        if addr < 0 or addr >= tuple_size(mem) do
          IO.puts("Modm address cell out of range: #{addr}. Line: #{line}")
          {:end, acc, mem, ret_stack}
        else
          divisor = elem(mem, addr)

          if divisor == 0 do
            IO.puts("Mod division by zero (mem[#{addr}]). Line: #{line}")
            {:end, acc, mem, ret_stack}
          else
            {line + 1, rem(acc, divisor), mem, ret_stack}
          end
        end

      :inc ->
        {line + 1, acc + 1, mem, ret_stack}

      :dec ->
        {line + 1, acc - 1, mem, ret_stack}

      :neg ->
        {line + 1, -acc, mem, ret_stack}

      :abs ->
        {line + 1, abs(acc), mem, ret_stack}

      :geti ->
        {line + 1, String.to_integer(String.trim(IO.gets(""))), mem, ret_stack}

      :puti ->
        IO.puts(acc)
        {line + 1, acc, mem, ret_stack}

      :getc ->
        <<code::utf8>> = IO.getn("", 1)
        {line + 1, code, mem, ret_stack}

      :putc ->
        IO.write(<<acc::utf8>>)
        {line + 1, acc, mem, ret_stack}

      {:puts, string} ->
        IO.puts(string)
        {line + 1, acc, mem, ret_stack}

      {:unknown, raw} ->
        IO.puts("Unknown command: #{raw}, line: #{line}")
        {line + 1, acc, mem, ret_stack}
    end
  end
end
