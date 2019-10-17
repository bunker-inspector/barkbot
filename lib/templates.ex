defmodule Templates do

  #Not exactly random yet...
  def random_render_tweet(twitter_at, animal_data) do
    """
    Hey {{twitter_at}}, it must be pretty cool living near {{contact_city}}!
    It would be even cooler if you adopted {{name}}, a/n {{age}}
    {{type}} in need of a home.

    """
    |> Mustache.render(Map.from_struct(animal_data) |> Map.put(:twitter_at, twitter_at))
  end
end
