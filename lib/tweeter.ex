defmodule Tweeter do
  use GenServer
  require Logger
  require Util
  require Poison
  import Ecto.Query
  alias Barkbot.Repo

  def get_page(page \\ 1) do
    %Scrivener.Page{entries: entries,
                    page_number: page_number,
                    total_pages: total_pages}
    = Animals
    |> where([a], a.status == "adoptable")
    |> order_by(fragment("RANDOM()"))
    |> where(fragment("json_array_length(photos) > 0"))
    |> where([a], a.type in ["Dog", "Cat", "Bird"])
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

  defmacro rate_limit_retry(expr) do
    quote do
      try do
        unquote(expr)
      rescue
        e in ExTwitter.RateLimitExceededError ->
          :timer.sleep ((e.reset_in + 1) * 1000)
          unquote(expr)
      end
    end
  end

  def tweet!(entry) do
    Logger.info "Tweeting about:", entry: entry

    lat = entry.coordinates.lat
    long = entry.coordinates.long
    tweets = rate_limit_retry ExTwitter.search("", geocode: "#{lat},#{long},25mi")
    lucky_soul_at = "@#{Enum.random(tweets).user.screen_name}"

    photo_url = Enum.random(entry.photos)["large"]
    photo_binary = image_to_binary photo_url

    text = Templates.random_render_tweet(entry |> Map.from_struct() |> Map.put(:twitter_at, lucky_soul_at))

    rate_limit_retry ExTwitter.API.Tweets.update_with_media(text, photo_binary)
  end

  defp sched_next(state, time \\ Util.minutes(10)) do
    Process.send_after self(), {:tweet, state}, time
  end

  @impl true
  def init(state) do
    Application.ensure_all_started :inets

    sched_next state

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

