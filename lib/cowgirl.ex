defmodule Cowgirl do
  @moduledoc """
  Cowgirl is a small, fast, modular HTTP server written in Elixir inspired by [Cowboy](https://github.com/ninenines/cowboy).
  """

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Cowgirl.Http, [8080]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cowgirl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
