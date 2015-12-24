defmodule Tqdm do

  @num_bars 10

  def tqdm(enumerable, opts \\ []) do
    now = :erlang.monotonic_time()

    state = %{
      n: 0,
      last_print_n: 0,
      start_time: now,
      last_print_time: now,
      last_printed_length: 0,
      prefix: Keyword.get(opts, :description, "") |> prefix(),
      total: Keyword.get_lazy(opts, :total, fn -> Enum.count(enumerable) end),
      clear: Keyword.get(opts, :clear, true),
      device: Keyword.get(opts, :device, :stderr),
      min_interval: Keyword.get(opts, :min_interval, 100),
      min_iterations: Keyword.get(opts, :min_iterations, 1)
    }

    Stream.transform(enumerable, fn -> state end, &do_tqdm/2, &do_tqdm_after/1)
  end

  defp prefix(""), do: ""
  defp prefix(description), do: description <> ": "

  defp do_tqdm(element, %{n: 0} = state) do
    {[element], %{print_status(state, :erlang.monotonic_time()) | n: 1}}
  end

  defp do_tqdm(element, %{n: n, last_print_n: last_print_n, min_iterations: min_iterations} = state)
  when n - last_print_n < min_iterations,
    do: {[element], %{state | n: n + 1}}

  defp do_tqdm(element, %{n: n, last_print_time: last_print_time, min_interval: min_interval} = state) do
    now = :erlang.monotonic_time()

    if :erlang.convert_time_unit(now - last_print_time, :native, :milli_seconds) >= min_interval do
      state = %{print_status(state, now) | last_print_n: n, last_print_time: :erlang.monotonic_time()}
    end

    {[element], %{state | n: n + 1}}
  end

  defp do_tqdm_after(state) do
    state = print_status(state, :erlang.monotonic_time())

    finish =
      if state.clear do
        "\r" <> String.duplicate(" ", String.length(state.prefix) + state.last_printed_length) <> "\r"
      else
        "\n"
      end

    IO.write(state.device, finish)
  end

  defp print_status(state, now) do
    status = format_status(state, now)
    status_length = String.length(status)

    padding = String.duplicate(" ", max(state.last_printed_length - status_length, 0))

    IO.write(state.device, "\r#{state.prefix}#{status}#{padding}")

    %{state | last_printed_length: status_length}
  end

  defp format_status(%{n: n, total: total, start_time: start_time}, now) do
    elapsed = :erlang.convert_time_unit(now - start_time, :native, :micro_seconds)

    total = if n <= total, do: total

    elapsed_str = format_interval(elapsed, false)

    rate = if elapsed > 0, do: Float.round(n / (elapsed / 1_000_000), 2), else: "?"

    if total do
      progress = n / total

      num_bars = trunc(progress * @num_bars)
      bar = String.duplicate("#", num_bars) <> String.duplicate("-", @num_bars - num_bars)

      percentage = "#{Float.round(progress * 100)}%"

      left_str = if n > 0, do: format_interval(elapsed / n * (total - n), true), else: "?"

      "|#{bar}| #{n}/#{total} #{percentage} [elapsed: #{elapsed_str} left: #{left_str}, #{rate} iters/sec]"
    else
      "#{n} [elapsed: #{elapsed_str}, #{rate} iters/sec]"
    end
  end

  defp format_interval(elapsed, trunc_seconds) do
    minutes = trunc(elapsed / 60_000_000)
    hours = div(minutes, 60)
    rem_minutes = minutes - hours * 60
    micro_seconds = elapsed - minutes * 60_000_000
    seconds = micro_seconds / 1_000_000

    if trunc_seconds do
      seconds = trunc(seconds)
    end

    hours_str = format_time_component(hours)
    minutes_str = format_time_component(rem_minutes)
    seconds_str = format_time_component(seconds)

    "#{hours_str}:#{minutes_str}:#{seconds_str}"
  end

  defp format_time_component(time) do
    time_string = to_string(time)

    if time < 10 do
      "0" <> time_string
    else
      time_string
    end
  end
end
