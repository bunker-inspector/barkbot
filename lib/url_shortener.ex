defmodule Url do
  use GenServer
  use Ecto.Schema

  import Ecto.Query

  alias Barkbot.Repo

  @shortened_url_len 6

  schema "urls" do
    field :long, :string
    field :short, :string
  end

  def get_next_id, do: (Repo.all(from u in Url, select: max(u.id)) |> List.first() || 0) + 1

  def id_to_url(id) do
    url_base = Integer.to_string(id, 16) |> String.downcase()

    case (@shortened_url_len - String.length(url_base)) do
      remaining when remaining >= 0 ->
        {:ok, String.duplicate("0", remaining) <> url_base}
      _ ->
        {:error, nil}
    end
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, get_next_id(), name: __MODULE__)
  end

  def shorten(url) do
    GenServer.call(__MODULE__ , {:shorten, url})
  end

  # Server (callbacks)
  @impl true
  def init(_) do
    {:ok, 0}
  end

  @impl true
  def handle_call({:shorten, url}, _from, curr_id) do
    {:reply, url, curr_id + 1}
  end
end
