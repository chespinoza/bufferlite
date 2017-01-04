[![License](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)](https://opensource.org/licenses/MIT)
# Bufferlite

**A Naive FIFO Buffer Queue with SQLite as persistence layer**

Bufferlite implements a persistent FIFO buffer on top of sqlitex package.

## Installation & Usage

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `bufferlite` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:bufferlite, "~> 0.1.0"}]
    end
    ```

  2. Ensure `bufferlite` is started before your application:

    ```elixir
    def application do
      [applications: [:bufferlite]]
    end
    ```
  3. Use it to buffer any Elixir/Erlang term.

  ```elixir
  >{:ok, pid} = Bufferlite.start_link("mybuff.db")
  >Bufferlite.new_buffer(pid, "buff")
  >Bufferlite.push(pid, "buff", {:ok, [1, 2, 3, 4], :some})
  >Bufferlite.pop(pid, "buff")
  {:ok, [1, 2, 3, 4], :some}
  ```
  4. TODO

  - Benchmarks

## License
MIT
