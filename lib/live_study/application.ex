defmodule LiveStudy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveStudyWeb.Telemetry,
      LiveStudy.Repo,
      {DNSCluster, query: Application.get_env(:live_study, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveStudy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveStudy.Finch},
      # Start a worker by calling: LiveStudy.Worker.start_link(arg)
      # {LiveStudy.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveStudyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveStudy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveStudyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
