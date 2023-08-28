defmodule Candle.Mongo do
  use Supervisor
  alias Mongo
  alias Candle.ParseUri

  @mongo_url Application.compile_env(:my_app, [:mongo, :url], "")

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    case ParseUri.parse(@mongo_url) do
      {:ok, config} ->
        children = [
          {Mongo, config}
        ]
        Supervisor.init(children, strategy: :one_for_one)
      {:error, reason} ->
        {:stop, reason}
    end
  end
end
