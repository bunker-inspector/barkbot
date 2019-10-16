defmodule Tweeter do
  use GenServer
  require Logger
  require Util
  import Ecto.Query
  alias Barkbot.Repo

  def get_page(page \\ 1) do
    %Scrivener.Page{entries: entries,
                    page_number: page_number,
                    total_pages: total_pages}
    = Animals
    |> order_by(fragment("RANDOM()"))
    |> preload(:coordinates)
    |> preload(:url)
    |> Repo.paginate(page: page)

    {entries, page_number, total_pages}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, get_page(), name: __MODULE__)
  end

  def image_to_binary(url) do
    url_binary = List.Chars.to_charlist(url)
    {:ok, {_, _, binary}} = :httpc.request(:get, {url_binary, []}, [], [body_format: :binary])
    binary
  end

  def tweet!(entry) do
    if false do
      lat = entry.coordinates.lat
      long = entry.coordinates.long
      tweets = ExTwitter.search("", geocode: "#{lat},#{long},25mi")
      lucky_soul = Enum.random(tweets).user
    end

    if Enum.empty? entry.photos do
      :nil
    else
      photo_url = Enum.random(entry.photos)["large"]
      photo_binary = image_to_binary photo_url

      ExTwitter.API.Tweets.update_with_media("THIS IS A TEST", photo_binary)
    end
  end

  defp sched_next(state, time \\ Util.minutes(10)) do
    Process.send_after self(), {:tweet, state}, time
  end

  @impl true
  def init(state) do
    Application.ensure_all_started :inets

    sched_next state, 15

    {:ok, nil}
  end

  @impl true
  def handle_info({:tweet, {[entry | r], page_number, total_pages}}, _) do
    tweet! entry

    sched_next {r, page_number, total_pages}

    {:noreply, nil}
  end

  @impl true
  def handle_info({:tweet, {[], page_number, total_pages}}, from) do
    state = get_page 1 + (if page_number >= total_pages, do: 0, else: page_number)
    handle_info {:tweet, state}, from
  end
end

