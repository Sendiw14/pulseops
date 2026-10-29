defmodule PulseOps.MixProject do
  use Mix.Project
  def project do
    [app: :pulse_ops, version: "0.1.0", elixir: "~> 1.17", start_permanent: Mix.env() == :prod, deps: deps()]
  end
  def application do
    [mod: {PulseOps.Application, []}, extra_applications: [:logger, :runtime_tools, :crypto]]
  end
  defp deps do
    [
      {:phoenix, "~> 1.8.0"}, {:phoenix_pubsub, "~> 2.1"}, {:ecto_sql, "~> 3.13"},
      {:postgrex, ">= 0.0.0"}, {:jason, "~> 1.4"}, {:bandit, "~> 1.5"},
      {:plug_crypto, "~> 2.1"}
    ]
  end
end
