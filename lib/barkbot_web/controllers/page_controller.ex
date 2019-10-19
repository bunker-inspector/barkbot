defmodule BarkbotWeb.PageController do
  use BarkbotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
