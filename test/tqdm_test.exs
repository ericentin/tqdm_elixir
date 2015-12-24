defmodule TqdmTest do
  use ExUnit.Case
  doctest Tqdm

  test "tqdm" do
    for _ <- Tqdm.tqdm(1..1000) do
      :timer.sleep(10)
    end
  end
end
