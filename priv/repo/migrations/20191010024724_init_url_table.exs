defmodule Barkbot.Repo.Migrations.InitUrlTable do
  use Ecto.Migration

  import Ecto.Query

  alias Barkbot.Repo

  def up do
    #46655 is 'ZZZ' in base 36
    Stream.chunk_every(1..46655, 1000)
    |> Enum.each(fn ck ->
      to_insert = Enum.map(ck, &(%{id: &1, short: Url.id_to_url(&1) |> elem(1)}))
      Repo.insert_all(Url, to_insert)
    end)
  end

  def down do
    Repo.delete_all(Url)
  end
end
