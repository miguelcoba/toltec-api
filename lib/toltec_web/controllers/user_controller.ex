defmodule ToltecWeb.UserController do
  use ToltecWeb, :controller

  alias Toltec.Accounts
  alias Toltec.Accounts.User
  alias Toltec.Auth.Guardian

  action_fallback(ToltecWeb.FallbackController)

  def create(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      new_conn = Guardian.Plug.sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)

      new_conn
      |> put_status(:created)
      |> render(ToltecWeb.SessionView, "show.json", user: user, jwt: jwt)
    end
  end
end
