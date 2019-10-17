defmodule Weather.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Weather"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~>1.3"},
      {:credo, "~>1.1", only: [:dev, :test]},
      {:jason, "~>1.1"},
      {:mint, "~>0.4"},
      {:castore, "~>0.1.3"}
    ]
  end
end
