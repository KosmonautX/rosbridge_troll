defmodule TrollWeb.PageController do
  use TrollWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
