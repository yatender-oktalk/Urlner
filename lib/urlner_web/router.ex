defmodule Urlner.Router do
  use UrlnerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Urlner do
    pipe_through :api
    forward "/link", Link.Router
  end
end
