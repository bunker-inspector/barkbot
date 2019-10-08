defmodule Api.Animals do
  alias Api.Auth

  @api_base "https://api.petfinder.com/v2/animals"

  def get(opts \\ []) do
    opts = Keyword.merge([limit: 100], opts)
    query = for {k, v} <- opts, into: %{}, do: {k,v} 

    HTTPotion.get!(@api_base, query: query, headers: Auth.header()).body |> Jason.decode!()
  end
end
