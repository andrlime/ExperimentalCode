# config/config.exs
import Config

config :candle, :mongo,
  url: "mongodb+srv://debateadmin:MhNh%23.Ut%23D-4._m@dlcapppilot.zo9xb.mongodb.net/?retryWrites=true&w=majority",
  database: "judges"

case Mix.env() do
  :dev ->
    Code.eval_file("config/dev.exs")
  :test ->
    Code.eval_file("config/test.exs")
  :prod ->
    Code.eval_file("config/prod.exs")
  _ ->
    raise "Unknown environment"
end
