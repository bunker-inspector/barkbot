defmodule Animals.Aggregator do
  use GenServer
  require Logger
  require Util
  alias Barkbot.Repo

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def handle_info(:aggregate, _) do
    animals = Animals.get(limit: 100, sort: "random")["animals"]

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    Repo.transaction fn ->
      db_animals = animals
      |>Enum.map(&Animals.api_to_db/1)
      |> Enum.map(fn record ->
        Map.merge(record, %{inserted_at: now, updated_at: now})
      end)

      Barkbot.Repo.insert_all Animals, db_animals,
        conflict_target: [:id],
        on_conflict: :replace_all_except_primary_key
    end

    Process.send_after self(), :aggregate, Util.minutes(5)

    {:noreply, nil}
  end

  @impl true
  def init(_) do
    if Url.urls_available() do
      Logger.info "Animals.Aggregator started."
      Process.send_after self(), :aggregate, Util.seconds(10)
    else
      Logger.warn "No URLs available. Animals.Aggregator not starting"
    end

    {:ok, nil}
  end
end
