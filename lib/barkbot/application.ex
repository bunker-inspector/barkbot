defmodule Barkbot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Barkbot.Repo, []}
      # Starts a worker by calling: Barkbot.Worker.start_link(arg)
      # {Barkbot.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Barkbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
