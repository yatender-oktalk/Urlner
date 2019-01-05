defmodule Urlner.Link.Helpers do

  alias Urlner.Link.{
    Model
  }

  @base_url "https://goo.gl/"
  # @link "http://example.com/about/index.html?uid=<%token%>"

  def get_link(_link) do
    {:ok, create_link(link)}
  end

  def create_link(link) do
    {url, uid} = extract_url_uid(link)
    unique_code_task = Task.async(fn ->
      get_uniq_code()
    end)
    #check url exists or not
    url_resp = Model.get_url(url)

    code = case url_resp do
      {:ok, resp} ->
        #shutdown the uniqe code task as code not required anymore
        Task.shutdown(unique_code_task)
        # we'll check for uid & if uid of resp & ours
        # are not same then we'll update for same url
        spawn(fn -> handle_uid_updation(resp, uid) end)
        resp[:code]

      {:error, _} ->
        spawn(fn -> handle_insert(link, code, uid) end)
        Task.await(unique_code_task)
        #for those whose url doesn't exists
    end
    short_url = code |> get_uniq_link
  end

  def handle_uid_updation(resp, uid) when uid in [nil, ""] do
    #do nothing
    ""
  end

  def handle_uid_updation(resp, uid) do
    case uid == resp[:uid] do
      true ->
        #do nothing
        "no need to update"
      false ->
        # make a changeset and update the uid
        Model.update_uid(resp, uid)
    end
  end

  def get_uniq_link(code) do
    "#{@base_url}#{code}"
  end

  def handle_insert(link, code, uid) do
    Model.insert_link(link, code, uid)
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
