defmodule Api.Mapquest.Geocoding do
  @api_base "http://www.mapquestapi.com/geocoding/v1/"

  defmacro consumer_key do
    System.get_env("MAPQUEST_CONSUMER_KEY")
  end

  def by_address(opts \\ []) do
    opts = Keyword.merge([key: consumer_key()], opts)
    query = for {k, v} <- opts, into: %{}, do: {k,v}

    HTTPotion.get!("#{@api_base}/address", query: query).body
    |> Jason.decode!()
    |> Map.get("results")
    |> hd
    |> Map.get("locations")
    |> hd
    |> Map.get("latLng")
  end
end
