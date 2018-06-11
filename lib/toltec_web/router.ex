defmodule ToltecWeb.Router do
  use ToltecWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ToltecWeb do
    pipe_through(:api)
  end
end
