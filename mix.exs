defmodule Bufferlite.Mixfile do
  use Mix.Project

  def project do
    [app: :bufferlite,
     version: "0.1.0",
     name: "Bufferlite",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package,
     description: """
      A Naive Persistent FIFO Buffer Queue on top of SQLite
     """]
  end

  def application do
    [applications: [:logger, :sqlitex]]
  end

  defp package do
    [maintainers: ["Christian Espinoza"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/chespinoza/bufferlite"},
    ]
  end

  defp deps do
    [
      {:sqlitex, "~> 1.0"},

      {:credo, "~> 0.5.3", only: :dev},
      {:dialyze, "~> 0.2.1", only: :dev},
    ]
  end
end
