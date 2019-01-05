defmodule Urlner.Link.Helpers do

  alias Urlner.Link.{
    Model
  }

  def get_link(_link) do
    {:ok, "link response"}
  end

  def get_uniq_code() do
    with code <- get_code(),
      true <- code |> code_uniq? do
        code
    else
      false -> get_uniq_code()
    end
  end

  def code_uniq?(code) do
    case code |> Model.get_code do
      {:error, _} -> false
      _ -> true
    end
  end

  def get_code(), do:
    Base.encode64(Ecto.UUID.generate |> binary_part(0,8), padding: false)

end
