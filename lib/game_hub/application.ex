defmodule GameHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        GameHubWeb.Telemetry,
        GameHub.Repo,
        {DNSCluster, query: Application.get_env(:game_hub, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: GameHub.PubSub},
        # Start the Finch HTTP client for sending emails
        {Finch, name: GameHub.Finch},
        # Start a worker by calling: GameHub.Worker.start_link(arg)
        # {GameHub.Worker, arg},
        # Start to serve requests, typically the last entry
        GameHubWeb.Endpoint,
        {Application.get_env(:game_hub, :nebulex_cache, GameHub.Cache), []},
        igdb_token_manager()
      ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GameHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp igdb_token_manager do
    if Application.get_env(:game_hub, :env) in [:dev, :prod] do
      {GameHub.IGDB.Token, Application.get_env(:game_hub, GameHub.IGDB)}
    else
      %{id: GameHub.IGDB.Token, start: {Function, :identity, [:ignore]}}
    end
  end
end
