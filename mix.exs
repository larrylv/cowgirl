defmodule Cowgirl.Mixfile do
  use Mix.Project

  def project do
    [app: :cowgirl,
     version: "0.0.1",
     description: "Small, fast, modular HTTP server written in Elixir.",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger],
     mod: {Cowgirl, []}]
  end

  defp deps do
    []
  end

  defp package do
    [
      maintainers: ["Larry Lv"],
      licenses: "MIT",
      links: %{"GitHub" => "https://github.com/larrylv/cowgirl",
               "Docs" => "https://github.com/larrylv/cowgirl"}
    ]
  end
end
