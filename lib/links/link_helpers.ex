defmodule Urlner.Link.Helpers do
  alias Urlner.Link.{
    Model
  }

  @base_url "https://goo.gl/"
  # @link "http://example.com/about/index.html?uid=token"

  @doc """
  this method will create short url
  """
  def create_link(link) do
    {:ok, handle_create(link)}
  end

  def handle_create(link) do
    # {url, uid} = extract_url_uid(link)
    code_task = Task.async(fn -> get_uniq_code() end)
    hash_resp = Model.get_hash(generate_hash(link))

    code =
      case hash_resp do
        {:error, nil} ->
          code = Task.await(code_task)
          spawn(fn ->
            hash = generate_hash(link)
            handle_insert(link, code, hash)
          end)

          code

        # for those whose url doesn't exists
        {:ok, row} ->
          # shutdown the uniqe code task as code not required anymore
          Task.shutdown(code_task)
          row.code
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
    code = get_code()
    case  code |> code_uniq?() do
      true ->
        code
      false ->
        get_uniq_code()
    end
  end

  def code_uniq?(code) do
    case code |> Model.get_code() do
      {:error, _} -> true
      _ -> false
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

  @doc """
  this def will give the original url from short url
  """
  def get_link(short_url) do
    with {code, key, val} <-  parse_url(short_url),
      {:ok, resp} <- Model.get_code(code) do
      {original_link, _, original_val} = parse_url(resp.url)

        uid =
          case {key, val} do
            {"token", ""} ->
              original_val
            {"token", val} ->
                val
            _ ->
              original_val

          end
        {:ok, generate_original_url(uid, original_link)}
    else
      {:error, _} ->
        {:error, "invalid or expired link"}
    end
  end

  def generate_original_url(uid, base_url) when uid in [nil, ""] do
    base_url
  end

  def generate_original_url(uid, base_url) do
    "#{base_url}?uid=#{uid}"
  end

  def parse_url(url) do
    param_url = String.replace(url, @base_url, "")
    case String.contains?(url, "?") == true and
    String.contains?(url, "=") == true
     do
      false ->
        {param_url, nil, nil}
      _ ->
        [code, param] = String.split(param_url, "?")
        [key, val] = String.split(param, "=")
        {code, key, val}
    end
  end

  def generate_hash(str) do
    :crypto.hash(:sha256, str)
    |> Base.encode16()
  end

  defp get_code(), do: Base.encode64(Ecto.UUID.generate() |> binary_part(0, 8), padding: false)
end
