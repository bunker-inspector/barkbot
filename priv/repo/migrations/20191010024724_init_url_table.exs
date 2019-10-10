defmodule Barkbot.Repo.Migrations.InitUrlTable do
  use Ecto.Migration

  alias Barkbot.Repo

  def up do
    Stream.chunk_every(1..0xffff, 500)
    |> Enum.each(fn ck ->
      to_insert = Enum.map(ck, &(%{id: &1, short: Url.id_to_url(&1) |> elem(1)}))
      Repo.insert_all(Url, to_insert)
    end)
  end

  def down do
    Repo.query("TRUNCATE urls", [])
  end
end
