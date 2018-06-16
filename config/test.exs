use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :toltec, ToltecWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :toltec, Toltec.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "toltec_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12

config :toltec, Toltec.Auth.Guardian,
  issuer: "toltec",
  secret_key: "secret"
