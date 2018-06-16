defmodule ToltecWeb.SessionViewTest do
  use ToltecWeb.ConnCase, async: true

  alias Toltec.Accounts
  alias ToltecWeb.SessionView

  @user_params %{name: "some name", email: "some@email", password: "some password"}

  test "show.json" do
    {:ok, user} = Accounts.create_user(@user_params)

    assert SessionView.render("show.json", %{user: user, jwt: "some token"}) == %{
             data: %{
               id: user.id,
               name: user.name,
               email: user.email
             },
             meta: %{token: "some token"}
           }
  end

  test "delete.json" do
    assert SessionView.render("delete.json", %{any: "value"}) == %{ok: true}
  end

  test "error.json" do
    assert SessionView.render("error.json", %{error: "a given error"}) == %{
             errors: %{error: "a given error"}
           }
  end
end
