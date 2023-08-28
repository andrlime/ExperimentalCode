defmodule Candle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Candle.Endpoints, options: [port: port()]},
      Candle.Mongo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Candle.Supervisor]
    Logger.info "The server has started at port: #{port()}..."
    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:candle, :port, 8000)
end
