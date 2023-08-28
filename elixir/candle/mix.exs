defmodule Candle.MixProject do
  use Mix.Project

  def project do
    [
      app: :candle,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :mongodb, :poolboy],
      mod: {Candle.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mongodb, "~> 1.0"},
      {:poolboy, "~> 1.5"},
      {:plug_cowboy, "~> 2.6"},
      {:jason, "~> 1.4"},
      {:config, "~> 0.1.0"}
    ]
  end
end
