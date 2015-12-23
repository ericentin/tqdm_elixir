# Tqdm

Add a progress bar to your enumerables in a second.

A port of Python's [tqdm](https://github.com/noamraph/tqdm) to Elixir. Thanks noamraph for the original library!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add tqdm to your list of dependencies in `mix.exs`:

        def deps do
          [{:tqdm, "~> 0.0.1"}]
        end

  2. Ensure tqdm is started before your application:

        def application do
          [applications: [:tqdm]]
        end

