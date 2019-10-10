defmodule Barkbot.Repo.Migrations.CreateAnimalsTable do
  use Ecto.Migration

  def up do
    create table(:urls) do
      add :long, :text
      add :short, :text
    end

    create table(:animals, primary_key: false) do
      add :id, :integer, primary_key: true
      add :age, :text
      add :declawed, :boolean
      add :breeds, :json
      add :coat, :text
      add :house_trained, :boolean
      add :shots_current, :boolean
      add :spayed_neutered, :boolean
      add :special_needs, :boolean
      add :mixed_breed, :boolean
      add :primary_breed, :boolean
      add :secondary_breed, :boolean
      add :tertiary_breed, :boolean
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
      add :status, :text
      add :type, :text
      add :url, references(:urls)

      timestamps()
    end
  end

  def down do
    drop table(:animals)
    drop table(:urls)
  end
end
