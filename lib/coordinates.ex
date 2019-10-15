defmodule Coordinates do
  use Ecto.Schema

  alias Barkbot.Repo
  alias Api.Mapquest.Geocoding

  schema "coordinates" do
    field :city, :string
    field :state, :string
    field :lat, :float
    field :long, :float
  end

  def insert(%{:city => city, :state => state}) do
    id = case Repo.get_by(Coordinates, [city: city, state: state]) do
           nil ->
             %{"lat" => lat, "lng" => long} = Geocoding.by_address(location: "#{city}, #{state}")

             {:ok, %{id: id}} =
               Repo.insert %Coordinates{city: city,
                                        state: state,
                                        lat: lat,
                                        long: long},
               conflict_target: [:city, :state],
               on_conflict: :nothing,
               returning: [:id]
             id
           %Coordinates{id: id} ->
             id
         end
    {:ok, id}
  end
end
