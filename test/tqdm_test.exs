defmodule TqdmTest do
  use ExUnit.Case
  import ExUnit.CaptureIO


  test "tqdm for" do
    assert_start_and_end "for: ", fn ->
      for _ <- Tqdm.tqdm(1..100, description: "for") do
        :timer.sleep(10)
      end
    end
  end

  test "tdqm enum" do
    assert_start_and_end ~S"Enum\.map: ", fn ->
      1..100
      |> Tqdm.tqdm(description: "Enum.map")
      |> Enum.map(fn _ -> :timer.sleep(10) end)
    end
  end

  test "tqdm stream" do
    assert_start_and_end ~S"Stream\.map: ", fn ->
      1..100
      |> Stream.map(fn _ -> :timer.sleep(10) end)
      |> Tqdm.tqdm(description: "Stream.map")
      |> Stream.run()
    end
  end

  test "tqdm optionless" do
    assert_start_and_end "", fn ->
      1..100
      |> Stream.map(fn _ -> :timer.sleep(10) end)
      |> Tqdm.tqdm()
      |> Stream.run()
    end
  end

  test "tqdm indeterminate" do
    fun = fn ->
      1..100
      |> Stream.map(fn _ -> :timer.sleep(10) end)
      |> Tqdm.tqdm(total: 0)
      |> Stream.run()
    end

    capture = capture_io(:stderr, fun)

    assert capture =~ ~r/0 \[elapsed: .*, 0\.0 iters\/sec]/
    assert capture =~ ~r/100 \[elapsed: .*, .* iters\/sec]/
  end

  defp assert_start_and_end(description, fun) do
    capture = capture_io(:stderr, fun)

    assert capture =~ start_regex_for_description(description)
    assert capture =~ end_regex_for_description(description)
  end

  defp start_regex_for_description(description) do
    ~r/#{description}\|----------\| 0\/100 0\.0% \[elapsed: .* left: \?, 0\.0 iters\/sec]/
  end

  defp end_regex_for_description(description) do
    ~r/#{description}\|##########\| 100\/100 100\.0% \[elapsed: .* left: 00:00:00, .* iters\/sec]/
  end
end
