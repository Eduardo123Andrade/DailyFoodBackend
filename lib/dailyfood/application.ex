defmodule Dailyfood.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Dailyfood.Repo,
      # Start the Telemetry supervisor
      DailyfoodWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dailyfood.PubSub},
      # Start the Endpoint (http/https)
      DailyfoodWeb.Endpoint,
      # Start a worker by calling: Dailyfood.Worker.start_link(arg)
      # {Dailyfood.Worker, arg}
      Dailyfood.RemovePdf.Sever
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dailyfood.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DailyfoodWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
