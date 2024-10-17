defmodule TimeManagerWeb.Plugs.EnsureRoleTest do
  use TimeManagerWeb.ConnCase, async: true
  alias TimeManagerWeb.Plugs.EnsureRole
  alias TimeManager.Accounts.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "EnsureRole plug" do
    test "allows access when user has the required role", %{conn: conn} do
      user = %User{id: 1, role: :manager}
      conn =
        conn
        |> assign(:current_user, user)
        |> EnsureRole.call([:employee, :manager])

      refute conn.halted
    end

    test "denies access when user doesn't have the required role", %{conn: conn} do
      user = %User{id: 1, role: :employee}
      conn =
        conn
        |> assign(:current_user, user)
        |> EnsureRole.call([:manager, :general_manager])

      assert conn.halted
      assert conn.status == 403
      assert Jason.decode!(conn.resp_body) == %{"errors" => %{"detail" => "Forbidden"}}
    end

    test "denies access when no user is assigned", %{conn: conn} do
      conn = EnsureRole.call(conn, [:employee, :manager, :general_manager])

      assert conn.halted
      assert conn.status == 403
      assert Jason.decode!(conn.resp_body) == %{"errors" => %{"detail" => "Forbidden"}}
    end
  end
end
