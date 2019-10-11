defmodule Url do
  use GenServer
  use Ecto.Schema

  import Ecto.Query

  alias Barkbot.Repo

  @shortened_url_len 4
  
  schema "urls" do
    field :long, :string
    field :short, :string
  end

  def fetch_ids() do
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
    GenServer.start_link(__MODULE__, fetch_ids(), name: __MODULE__)
  end

  def shorten(url) do
    GenServer.call(__MODULE__ , {:shorten, url})
  end

  # Server (callbacks)
  @impl true
  def init(init_ids) do
    {:ok, init_ids}
  end

  @impl true
  def handle_call({:shorten, url}, from, []) do
    handle_call({:shorten, url}, from, fetch_ids())
  end

  @impl true
  def handle_call({:shorten, url}, _from, [curr_id | queue]) do
    {:ok, %{short: short}} = Repo.insert %Url{id: curr_id, long: url, short: ""},
      conflict_target: [:id],
      on_conflict: {:replace, [:long]},
      returning: [:short]

    {:reply, {curr_id, short}, queue}
  end
end
