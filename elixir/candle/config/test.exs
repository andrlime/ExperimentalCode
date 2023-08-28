import Config

# Importing the configuration depending on the environment.
# If Mix.env() == "dev", we'll have import_config "dev.exs"
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
