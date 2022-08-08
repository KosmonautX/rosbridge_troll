defmodule TrollWeb.OperationLiveTest do
  use TrollWeb.ConnCase

  import Phoenix.LiveViewTest
  import Troll.ProtocolFixtures

  @create_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", op: "some op", topic: "some topic", type: "some type"}
  @update_attrs %{id: "7488a646-e31f-11e4-aace-600308960668", op: "some updated op", topic: "some updated topic", type: "some updated type"}
  @invalid_attrs %{id: nil, op: nil, topic: nil, type: nil}

  defp create_operation(_) do
    operation = operation_fixture()
    %{operation: operation}
  end

  describe "Index" do
    setup [:create_operation]

    test "lists all operations", %{conn: conn, operation: operation} do
      {:ok, _index_live, html} = live(conn, Routes.operation_index_path(conn, :index))

      assert html =~ "Listing Operations"
      assert html =~ operation.op
    end

    test "saves new operation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.operation_index_path(conn, :index))

      assert index_live |> element("a", "New Operation") |> render_click() =~
               "New Operation"

      assert_patch(index_live, Routes.operation_index_path(conn, :new))

      assert index_live
             |> form("#operation-form", operation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#operation-form", operation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.operation_index_path(conn, :index))

      assert html =~ "Operation created successfully"
      assert html =~ "some op"
    end

    test "updates operation in listing", %{conn: conn, operation: operation} do
      {:ok, index_live, _html} = live(conn, Routes.operation_index_path(conn, :index))

      assert index_live |> element("#operation-#{operation.id} a", "Edit") |> render_click() =~
               "Edit Operation"

      assert_patch(index_live, Routes.operation_index_path(conn, :edit, operation))

      assert index_live
             |> form("#operation-form", operation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#operation-form", operation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.operation_index_path(conn, :index))

      assert html =~ "Operation updated successfully"
      assert html =~ "some updated op"
    end

    test "deletes operation in listing", %{conn: conn, operation: operation} do
      {:ok, index_live, _html} = live(conn, Routes.operation_index_path(conn, :index))

      assert index_live |> element("#operation-#{operation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#operation-#{operation.id}")
    end
  end

  describe "Show" do
    setup [:create_operation]

    test "displays operation", %{conn: conn, operation: operation} do
      {:ok, _show_live, html} = live(conn, Routes.operation_show_path(conn, :show, operation))

      assert html =~ "Show Operation"
      assert html =~ operation.op
    end

    test "updates operation within modal", %{conn: conn, operation: operation} do
      {:ok, show_live, _html} = live(conn, Routes.operation_show_path(conn, :show, operation))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Operation"

      assert_patch(show_live, Routes.operation_show_path(conn, :edit, operation))

      assert show_live
             |> form("#operation-form", operation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#operation-form", operation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.operation_show_path(conn, :show, operation))

      assert html =~ "Operation updated successfully"
      assert html =~ "some updated op"
    end
  end
end
