defmodule BarkbotWeb.RedirectController do
  use BarkbotWeb, :controller

  def redirect_to_long(conn, %{"short_url" => short_url}) do
    {_, long_url} = Url.get(short_url)
    redirect(conn, external: long_url)
  end
end
