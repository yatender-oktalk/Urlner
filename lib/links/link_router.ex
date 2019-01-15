defmodule Urlner.Link.Router do
  @moduledoc """
  module to route the Link related requestes
  """
  use UrlnerWeb, :router

  alias Urlner.Link.{
    Controller
  }

  get("/health", Controller, :health)
  post("/", Controller, :create)
  post("/original", Controller, :index)
  # put "/:id", LinkController, :activate_link
  # delete "/:id", LinkController, :deactivate_link
end
