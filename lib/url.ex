defmodule Url do
  use Agent
  use Ecto.Schema
  require Logger
  import Ecto.Query
  alias Barkbot.Repo

  @shortened_url_len 4

  schema "urls" do
    field :long, :string
    field :short, :string
  end

  def fetch_ids() do
    Logger.info "Animals.Aggregator fetching IDs"
    (from u in Url,
      select: [:id],
      order_by: fragment("RANDOM()"),
      where: is_nil(u.long),
      limit: 100)
      |> Repo.all()
      |> Enum.map(&(&1.id))
  end

  def id_to_url(id) do
    url_base = Integer.to_string(id, 36) |> String.downcase()

    case (@shortened_url_len - String.length(url_base)) do
      remaining when remaining >= 0 ->
        {:ok, String.duplicate("0", remaining) <> url_base}
      _ ->
        {:error, nil}
    end
  end

  def start_link(_) do
    Agent.start_link(&fetch_ids/0, name: __MODULE__)
  end

  def shorten(url) do
    shorten(url, Agent.get(__MODULE__, & &1))
  end

  def shorten(url, [curr_id | queue]) do
    IO.puts curr_id
    %{short: short} = Repo.insert! %Url{id: curr_id, long: url, short: ""},
      conflict_target: [:id],
      on_conflict: {:replace, [:long]},
      returning: [:short]

    Agent.update(__MODULE__, fn _ -> queue end)

    {:ok, {curr_id, short}}
  end

  def shorten(url, []) do
    ids = fetch_ids()

    if Enum.empty? ids do
      Logger.info "No more free IDs available. Halting"

      {:error, nil}
    else
      shorten url, ids
    end
  end

  def get(short_url) do
    Cachex.fetch :url_cache, short_url, fn short_url ->
      Repo.get_by!(Url, [short: short_url]).long
    end
  end

  def urls_available do
    queue = Agent.get(__MODULE__, & &1)

    if !Enum.empty? queue do
      true
    else
      next_batch = fetch_ids()
      if Enum.empty? next_batch do
        false
      else
        Agent.update(__MODULE__, fn _ -> next_batch end)
        true
      end
    end
  end
end
