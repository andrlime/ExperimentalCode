defmodule Candle.Endpoints do
  use Plug.Router

  alias Services.CandleService

  plug :match

  # We want the response to be sent in json format.
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug :dispatch

  get "/all" do
    # We call the service to get all the movies.
    response = "A"
    conn |> send_resp(200, response)
  end
end
