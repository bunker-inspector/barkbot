defmodule BarkbotWeb.Router do
  use BarkbotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BarkbotWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/", BarkbotWeb do
    get "/:short_url", RedirectController, :redirect_to_long
  end
end
