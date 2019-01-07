defmodule Urlner.Behaviours.NetworkProvider do
  @type path :: binary()
  @type body :: map()
  @type reason :: atom()
  @type response :: binary()

  @callback get(path) :: {:ok, response} | {:error, reason}

  @callback post(path, body) :: {:ok, response} | {:error, reason}

end
