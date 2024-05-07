defmodule GenTcp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@localhost", :"b@localhost"]]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: GenTcp.ClusterSupervisor]]},
      # Starts a worker by calling: GenTcp.Worker.start_link(arg)
      # {GenTcp.Worker, arg}

      %{id: GenTcp.Server, start: {GenTcp.Server, :start_link, [[]]}},
      %{id: GenTcp.Client, start: {GenTcp.Client, :start_link, [[]]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenTcp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
