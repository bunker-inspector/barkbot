defmodule Animals.Aggregator do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def handle_info(:aggregate, _) do
    animals = Animals.get(limit: 100, sort: "random")["animals"]

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    db_animals = Enum.map(animals, &Animals.api_to_db/1)
    |> Enum.map(fn record ->
      Map.merge(record, %{inserted_at: now, updated_at: now})
    end)

    Barkbot.Repo.insert_all(Animals, db_animals)

    Process.send_after self(), :aggregate, 60 * 1000
  end

  @impl true
  def init(_) do
    IO.puts "Animals.Aggregator started."

    Process.send_after self(), :aggregate, 60 * 1000
    {:ok, nil}
  end
end
