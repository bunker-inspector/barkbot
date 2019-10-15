defmodule Barkbot.Repo.Migrations.CreateAnimalsTable do
  use Ecto.Migration

  def up do
    create table("urls") do
      add :long, :text
      add :short, :text, null: false
    end

    create index("urls", [:long])
    create unique_index("urls", [:short])

    create table("coordinates") do
      add :city, :text
      add :state, :text
      add :lat, :float
      add :long, :float
    end

    create unique_index("coordinates", [:city, :state])

    create table("animals", primary_key: false) do
      add :id, :integer, primary_key: true
      add :age, :text
      add :declawed, :boolean
      add :coat, :text
      add :primary_color, :text
      add :secondary_color, :text
      add :tertiary_color, :text
      add :house_trained, :boolean
      add :shots_current, :boolean
      add :spayed_neutered, :boolean
      add :special_needs, :boolean
      add :mixed_breed, :boolean
      add :primary_breed, :text
      add :secondary_breed, :text
      add :breed_unknown, :boolean
      add :contact_address_1, :text
      add :contact_address_2, :text
      add :contact_city, :text
      add :contact_country, :text
      add :contact_postcode, :text
      add :contact_state, :text
      add :contact_email, :text
      add :contact_phone, :text
      add :description, :text
      add :distance, :integer
      add :name, :text
      add :environment, :json
      add :gender, :text
      add :organization_id, :text
      add :photos, :json
      add :size, :text
      add :tags, :json
      add :status, :text
      add :type, :text
      add :url_id, references(:urls, on_delete: :nilify_all)
      add :coordinate_id, references(:coordinates)

      timestamps()
    end

    create index("animals", [:status])
    create index("animals", [:type])
  end

  def down do
    drop index("animals", "animals_url_fkey")

    drop table(:animals)
    drop table(:urls)
    drop table(:coordinates)
  end
end
