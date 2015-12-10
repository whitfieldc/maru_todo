defmodule MaruTodo.Mixfile do
  use Mix.Project

  def project do
    [ app: :maru_todo,
      version: "0.0.1",
      elixir: "~> 1.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [applications: [:logger, :maru, :postgrex, :ecto], mod: {MaruTodo, []}]
  end

  defp deps do
    [ {:maru, "~> 0.8"},
      {:cors_plug, "~> 0.1.4"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 1.0"}
    ]
  end
end
