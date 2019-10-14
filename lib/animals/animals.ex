defmodule Animals do
  use Ecto.Schema

  import Ecto.Query

  alias Api.Petfinder.Auth
  alias Barkbot.Repo

  @api_base "https://api.petfinder.com/v2/animals"

  schema "animals" do
    field :age, :string
    field :declawed, :boolean
    field :coat, :string
    field :primary_color, :string
    field :secondary_color, :string
    field :tertiary_color, :string
    field :house_trained, :boolean
    field :shots_current, :boolean
    field :spayed_neutered, :boolean
    field :special_needs, :boolean
    field :mixed_breed, :boolean
    field :primary_breed, :string
    field :secondary_breed, :string
    field :breed_unknown, :boolean
    field :contact_address_1, :string
    field :contact_address_2, :string
    field :contact_city, :string
    field :contact_country, :string
    field :contact_postcode, :string
    field :contact_state, :string
    field :contact_email, :string
    field :contact_phone, :string
    field :description, :string
    field :distance, :integer
    field :name, :string
    field :environment, :map
    field :gender, :string
    field :organization_id, :string
    field :photos, {:array, :map}
    field :size, :string
    field :status, :string
    field :type, :string
    field :url_id, :integer

    has_one :url, Url, references: :id

    timestamps()
  end

  def get(opts \\ []) do
    opts = Keyword.merge([limit: 100], opts)
    query = for {k, v} <- opts, into: %{}, do: {k,v} 

    HTTPotion.get!(@api_base, query: query, headers: Auth.header()).body |> Jason.decode!()
  end

  def api_to_db(api_record) do
    %{"age" => age,
      "attributes" => %{
        "declawed" => declawed,
        "house_trained" => house_trained,
        "shots_current" => shots_current,
        "spayed_neutered" => spayed_neutered,
        "special_needs" => special_needs
      },
      "breeds" => %{
        "mixed" => mixed_breed,
        "primary" => primary_breed,
        "secondary" => secondary_breed,
        "unknown" => unknown_breed
      },
      "coat" => coat,
      "colors" => %{
        "primary" => primary_color,
        "secondary" => secondary_color,
        "tertiary" => tertiary_color
      },
      "contact" => %{
        "address" => %{
          "address1" => contact_address_1,
          "address2" => contact_address_2,
          "city" => contact_city,
          "country" => contact_country,
          "postcode" => contact_postcode,
          "state" => contact_state
        },
        "email" => contact_email,
        "phone" => contact_phone
      },
      "description" => description,
      "distance" => distance,
      "environment" => environment,
      "gender" => gender,
      "id" => id,
      "name" => name,
      "organization_id" => organization_id,
      "photos" => photos,
      "size" => size,
      "status" => status,
      "type" => type,
      "url" => url
    } = api_record

    {:ok, {url_id, _}} = Url.shorten(url)

    %{
      id: id,
      age: age,
      declawed: declawed,
      house_trained: house_trained,
      shots_current: shots_current,
      spayed_neutered: spayed_neutered,
      special_needs: special_needs,
      primary_breed: primary_breed,
      secondary_breed: secondary_breed,
      breed_unknown: unknown_breed,
      coat: coat,
      primary_color: primary_color,
      secondary_color: secondary_color,
      tertiary_color: tertiary_color,
      contact_address_1: contact_address_1,
      contact_address_2: contact_address_2,
      contact_city: contact_city,
      contact_country: contact_country,
      contact_state: contact_state,
      contact_email: contact_email,
      contact_phone: contact_phone,
      description: description,
      distance: distance,
      environment: environment,
      gender: gender,
      name: name,
      size: size,
      photos: photos,
      status: status,
      type: type,
      url_id: url_id
    }
  end
end
