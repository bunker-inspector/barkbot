defmodule Barkbot.MixProject do
  use Mix.Project

  def project do
    [
      app: :barkbot,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpotion],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.3"},
      {:jason, "~> 1.1"},
      {:postgrex, "~> 0.15.1"},
      {:ecto, "~> 3.2.2"},
      {:ecto_sql, "~> 3.2.0"},
      {:distillery, "~> 2.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
