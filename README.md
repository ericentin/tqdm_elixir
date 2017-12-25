[![Build Status](https://travis-ci.org/antipax/tqdm_elixir.svg?branch=master)](https://travis-ci.org/antipax/tqdm_elixir) [![Coverage Status](https://coveralls.io/repos/github/antipax/tqdm_elixir/badge.svg?branch=master)](https://coveralls.io/github/antipax/tqdm_elixir?branch=master) [![Inline docs](http://inch-ci.org/github/antipax/tqdm_elixir.svg?branch=master)](http://inch-ci.org/github/antipax/tqdm_elixir) [![Hex.pm package version](https://img.shields.io/hexpm/v/tqdm.svg)](https://hex.pm/packages/tqdm) [![Hex.pm package license](https://img.shields.io/hexpm/l/tqdm.svg)](https://github.com/antipax/tqdm_elixir/blob/master/LICENSE)

# Tqdm

Tqdm easily adds a CLI progress bar to any enumerable.

![tqdm](http://i.imgur.com/D4ZILgE.gif)

A (partial) port of Python's [tqdm](https://github.com/tqdm/tqdm) to Elixir. Thanks noamraph and all other contributors for the original library!

Just wrap Lists, Maps, Streams, or anything else that implements Enumerable with `Tqdm.tqdm`:

```elixir
for _ <- Tqdm.tqdm(1..1000) do
  :timer.sleep(10)
end

# or

1..1000
|> Tqdm.tqdm()
|> Enum.map(fn _ -> :timer.sleep(10) end)

# or even...

1..1000
|> Stream.map(fn _ -> :timer.sleep(10) end)
|> Tqdm.tqdm(total: 1000)
|> Stream.run()

# |###-------| 392/1000 39.0% [elapsed: 00:00:04.627479 left: 00:00:07, 84.71 iters/sec]
```

Full documentation can be found [here](https://hexdocs.pm/tqdm/0.0.2).

## Installation

  1. Add tqdm to your list of dependencies in `mix.exs`:

        def deps do
          [{:tqdm, "~> 0.0.2"}]
        end

  2. Ensure tqdm is added to your list of applications:

        def application do
          [applications: [:tqdm]]
        end

