defmodule Barkbot.Application do
# See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  import Supervisor.Spec
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Barkbot.Repo,
      BarkbotWeb.Endpoint,
      Url,
      Animals.Aggregator,
      #Tweeter,
      worker(Cachex, [:url_cache, [limit: 100,
                                   policy: Cachex.Policy.LRW]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Barkbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BarkbotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
