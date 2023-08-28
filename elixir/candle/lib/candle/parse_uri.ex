defmodule Candle.ParseUri do
  @moduledoc """
  Helper module to parse MongoDB connection URI.
  """

  require Logger

  def parse(mongo_url) do
    case URI.parse(mongo_url) do
      %URI{
        scheme: "mongodb+srv",
        userinfo: userinfo,
        host: hostname,
        path: path,
        query: query
      } ->
        [username, password] = String.split(userinfo, ":")
        port = 27017
        database = String.trim_leading(path, "/")
        options = parse_query(query)

        Logger.info("Parsed MongoDB URI components:")
        Logger.info("  Username: #{username}")
        Logger.info("  Password: #{password}")
        Logger.info("  Hostname: #{hostname}")
        Logger.info("  Port: #{port}")
        Logger.info("  Database: #{database}")
        Logger.info("  Options: #{inspect(options)}")

        {
          :ok,
          [
            scheme: "mongodb",
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database,
            ssl: true,
            extra: options
          ]
        }

      _ ->
        {:error, :invalid_mongo_url}
    end
  end

  defp parse_query(query) do
    query
    |> URI.query_decoder()
    |> Enum.into(%{})
  end
end
