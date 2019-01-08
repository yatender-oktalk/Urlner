defmodule Urlner.LinkMacros do
  defmacro generate_dao(proplist) do
    proplist |> Enum.map(fn property ->
      quote do

        def unquote(:"get_#{property}")(value) when value in ["", nil] do
          {:error, nil}
        end

        def unquote(:"get_#{property}")(value) do
          query =
            from u in Urlner.Link.Model,
            where: u.unquote(property) == ^value and u.is_active == true and u.expire_time > ^Timex.now(),
            select: u

          execute_one(query)
        end
      end
    end)
  end
end