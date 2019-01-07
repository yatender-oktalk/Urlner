defmodule Urlner.Link.Test do
  use ExUnit.Case

  alias Urlner.Link.{Helpers}

    test "generate short url without params & get original url" do
      original_url = "https://github.com/bluzky/extus"

      {:ok, response} = Helpers.create_link(original_url)
      {:ok, original_link_response} = Helpers.get_link(response)

      assert original_url == original_link_response
    end

    test "get original url having params from short url passing token in short url" do
      original_url = "https://golang.org/src/sort/example_test.go?uid=890789"
      {:ok, response} = Helpers.create_link(original_url)
      {:ok, original_link_response} = Helpers.get_link(response)

      assert original_url == original_link_response
    end

    test "invalid short url passing" do
      original_url = "https://golang.org/src/sort/example_test.go?uid=890789"

      {:ok, _response} = Helpers.create_link(original_url)
      {:error, fake_link_response} = Helpers.get_link("http://random.invalid.url")

      assert fake_link_response != original_url
    end

end