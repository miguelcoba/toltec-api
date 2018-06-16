defmodule Toltec.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :toltec,
    module: Toltec.Auth.Guardian,
    error_handler: Toltec.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
