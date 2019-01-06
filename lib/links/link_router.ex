defmodule Urlner.Link.Router do
  @moduledoc """
  module to route the Link related requestes
  """
  use UrlnerWeb, :router

  alias Urlner.Link.{
    Controller
  }

  get("/", Controller, :index)
  get("/:link", LinkController, :get_link_details)
  # post "/", LinkController, :create
  # post "/:link/validate", LinkController, :validate_link
  # put "/:id", LinkController, :activate_link
  # delete "/:id", LinkController, :deactivate_link
end
