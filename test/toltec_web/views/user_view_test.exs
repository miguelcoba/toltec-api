defmodule ToltecWeb.UserViewTest do
  use ToltecWeb.ConnCase, async: true

  alias Toltec.Accounts
  alias ToltecWeb.UserView

  @user_params %{name: "some name", email: "some@email", password: "some password"}

  test "index.json" do
    {:ok, user} = Accounts.create_user(@user_params)

    assert UserView.render("user.json", %{user: user}) == %{
             id: user.id,
             name: user.name,
             email: user.email
           }
  end
end
