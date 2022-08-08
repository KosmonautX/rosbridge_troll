defmodule Troll.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Troll.Repo,
      # Start the Telemetry supervisor
      TrollWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Troll.PubSub},
      # Start the Endpoint (http/https)
      TrollWeb.Endpoint,
      # Start a worker by calling: Troll.Worker.start_link(arg)
      {Troll.Bridge, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Troll.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrollWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
