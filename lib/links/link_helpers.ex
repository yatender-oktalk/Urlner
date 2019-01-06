defmodule Urlner.Link.Helpers do
  alias Urlner.Link.{
    Model
  }

  @base_url "https://goo.gl/"
  # @link "http://example.com/about/index.html?uid=token"

  def get_link(link) do
    {:ok, create_link(link)}
  end

  def create_link(link) do
    {url, uid} = extract_url_uid(link)
    code_task = Task.async(fn -> get_uniq_code() end)
    url_existing_code = Model.get_url_uid({url, uid})

    code =
      case url_existing_code do
        nil ->
          code = Task.await(code_task)
          spawn(fn -> handle_insert(url, code, uid) end)
          code

        # for those whose url doesn't exists
        _ ->
          # shutdown the uniqe code task as code not required anymore
          Task.shutdown(code_task)
          url_existing_code
      end

    code |> get_uniq_link
  end

  def get_uniq_link(code) do
    "#{@base_url}#{code}"
  end

  def handle_insert(link, code, uid) do
    Model.insert_link(link, code, uid)
  end

  def get_uniq_code() do
    case code = get_code() |> code_uniq?() do
      true ->
        code
      false ->
        get_uniq_code()
    end
  end

  defp code_uniq?(code) do
    case code |> Model.get_code() do
      {:error, _} -> false
      _ -> true
    end
  end

  def extract_url_uid(url) do
    case String.contains?(url, "?") == true do
      false ->
        {url, nil}

      _ ->
        [original_link, param] = String.split(url, "?")
        [_key, val] = String.split(param, "=")
        {original_link, val}
    end
  end

  def get_original_link(short_url) do
    with {code, key, val} <-  parse_short_url(short_url),
      {:ok, resp} <- Model.get_code(code) do
        base_url = resp[:url]

        uid =
          case {key, val} do
            {"token", val} ->
              val
            _ ->
              resp[:uid]
          end
        {:ok, generate_original_url(uid, base_url)}
    else
      {:error, _} ->
        {:error, "invalid or expired link"}
    end
  end

  def generate_original_url(uid, base_url) do
    case uid do
      nil ->
        "#{base_url}"
      "" ->
        "#{base_url}"
      _ ->
        "#{base_url}?uid=#{uid}"
    end
  end

  def parse_short_url(url) do
    param_url = String.replace(url, @base_url, "")
    case String.contains?(url, "?") == true do
      false ->
        {param_url, nil, nil}
      _ ->
        [code, param] = String.split(param_url, "?")
        [key, val] = String.split(param, "=")
        {code, key, val}
    end
  end

  defp get_code(), do: Base.encode64(Ecto.UUID.generate() |> binary_part(0, 8), padding: false)
end
