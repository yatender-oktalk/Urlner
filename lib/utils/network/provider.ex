defmodule Urlner.Network.Provider do

  @target Urlner.Network.Provider.Tesla

  defdelegate get(path), to: @target
  defdelegate post(path, body), to: @target
end
