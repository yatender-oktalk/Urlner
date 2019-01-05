defmodule Urlner.Link.Helpers do

  alias Urlner.Link.{
    Model
  }

  @base_url "https://goo.gl/"
  # @link "http://example.com/about/index.html?uid=<%token%>"

  def get_link(_link) do
    {:ok, "link response"}
  end

  def create_link() do

  end

  def get_uniq_link() do
    "#{@base_url}#{get_uniq_code()}"
  end

  def get_uniq_code() do
    with code <- get_code(),
      true <- code |> code_uniq? do
        code
    else
      false -> get_uniq_code()
    end
  end

  defp code_uniq?(code) do
    case code |> Model.get_code do
      {:error, _} -> false
      _ -> true
    end
  end

  def extract_url_uid(url) do
    case String.contains?(url, "?") == true do
      false ->
        {url, nil}
      _ ->
        [original_link , "uid=<%"<> uid] = String.split(url,"?")
        {original_link, uid |> String.replace("%>", "")}

        # regex can also be used but for simplicity let's use string replace
        # [_, uid] = String.split(url,"?")
        # regex = ~r/uid=<%(?<uid>.+)%(?>.+)/
        # {"uid" => uid} = Regex.named_captures(regex, uid)
        # uid
    end
  end

  defp get_code(), do:
    Base.encode64(Ecto.UUID.generate |> binary_part(0,8), padding: false)

end
