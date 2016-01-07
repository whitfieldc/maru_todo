# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

config :maru, MaruTodo.API,
	http: [port: 8880]

config :maru_todo, MaruTodo.Repo,
	adapter: Ecto.Adapters.Postgres,
	database: "maru_todo"

config :maru_todo, base_url: (Mix.env == :dev && "http://localhost:8880/tasks/" || "http://maru-todo.herokuapp.com/tasks/")
# You can configure for your application as:
#
#     config :maru_todo, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:maru_todo, :key)
#u
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
