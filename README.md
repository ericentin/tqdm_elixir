# TqdmElixir

Add a progress bar to your enumerables in a second.

A port of Python's [tqdm](https://github.com/noamraph/tqdm) to Elixir. Thanks noamraph for the original library!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add tqdm_elixir to your list of dependencies in `mix.exs`:

        def deps do
          [{:tqdm_elixir, "~> 0.0.1"}]
        end

  2. Ensure tqdm_elixir is started before your application:

        def application do
          [applications: [:tqdm_elixir]]
        end
