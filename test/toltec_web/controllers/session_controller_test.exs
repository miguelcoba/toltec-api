defmodule ToltecWeb.SessionControllerTest do
  use ToltecWeb.ConnCase

  alias Toltec.Accounts
  alias Toltec.Auth.Guardian

  @valid_params %{name: "some name", email: "some@email", password: "some password"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST to /sessions" do
    setup [:create_user]

    test "logs in a user when the required params are provided", %{conn: conn, user: user} do
      response =
        conn
        |> post(session_path(conn, :create), @valid_params)
        |> json_response(:created)

      expected = %{"id" => user.id, "name" => user.name, "email" => user.email}

      assert expected == response["data"]
      refute Map.get(response["data"], :password)
      assert %{"token" => _token} = response["meta"]
    end

    test "rejects log in if incorrect params provided", %{conn: conn} do
      response =
        conn
        |> post(session_path(conn, :create), @invalid_attrs)
        |> json_response(:unauthorized)

      assert %{"errors" => %{"error" => "User or email invalid"}} = response
      refute response["meta"]
    end
  end

  describe "DELETE to /sessions" do
    setup [:create_user]

    test "access should be denied if no token on request", %{conn: conn} do
      response =
        conn
        |> delete(session_path(conn, :delete))
        |> json_response(:unauthorized)

      assert %{"error" => "Not Authenticated"} = response
    end

    test "access should be denied if no valid token on request", %{conn: conn} do
      response =
        conn
        |> put_req_header("authorization", "Bearer: some_invalid_token")
        |> delete(session_path(conn, :delete))
        |> json_response(:unauthorized)

      assert %{"error" => "Invalid Token"} = response
    end

    test "access should be denied if no resource is found for a valid token on request", %{
      conn: conn,
      user: user
    } do
      {:ok, token, _} = Guardian.encode_and_sign(user)
      assert {:ok, _} = Accounts.delete_user(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer: #{token}")
        |> delete(session_path(conn, :delete))
        |> json_response(:unauthorized)

      assert %{"error" => "No Resource Found"} = response
    end

    test "logs out a user when is already logged in", %{conn: conn, user: user} do
      {:ok, token, _} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer: #{token}")
        |> delete(session_path(conn, :delete))
        |> json_response(:no_content)

      assert %{"ok" => true} = response
      refute response["meta"]
    end
  end

  describe "POST to /sessions/refresh" do
    setup [:create_user]

    test "access should be denied if no token on request", %{conn: conn} do
      response =
        conn
        |> post(session_path(conn, :refresh))
        |> json_response(:unauthorized)

      assert %{"error" => "Not Authenticated"} = response
    end

    test "access should be denied if no valid token on request", %{conn: conn} do
      response =
        conn
        |> put_req_header("authorization", "Bearer: some_invalid_token")
        |> post(session_path(conn, :refresh))
        |> json_response(:unauthorized)

      assert %{"error" => "Invalid Token"} = response
    end

    test "access should be denied if no resource is found for a valid token on request", %{
      conn: conn,
      user: user
    } do
      {:ok, token, _} = Guardian.encode_and_sign(user)
      assert {:ok, _} = Accounts.delete_user(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer: #{token}")
        |> post(session_path(conn, :refresh))
        |> json_response(:unauthorized)

      assert %{"error" => "No Resource Found"} = response
    end

    test "refreshes a token if a valid one is provided", %{conn: conn, user: user} do
      {:ok, token, _} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer: #{token}")
        |> post(session_path(conn, :refresh))
        |> json_response(:ok)

      expected = %{"id" => user.id, "name" => user.name, "email" => user.email}

      assert expected == response["data"]
      refute Map.get(response["data"], :password)
      assert %{"token" => new_token} = response["meta"]
      refute token == new_token
    end
  end

  defp create_user(_) do
    {:ok, user} = Accounts.create_user(@valid_params)
    {:ok, user: user}
  end
end
