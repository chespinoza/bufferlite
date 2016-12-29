# Bufferlite

**A Naive Persistent FIFO Buffer Queue on top of SQLite**

## Installation

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
