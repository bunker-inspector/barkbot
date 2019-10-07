defmodule Api.Animals do
  alias Api.Auth

  @api_base "https://api.petfinder.com/v2/animals"

  def get(opts \\ []) do
    query = for {k, v} <- opts, into: %{}, do: {k,v}

    HTTPotion.get!(@api_base, query: query, headers: Auth.header())
  end
end
