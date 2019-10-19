defmodule Templates do
  defmacro domain do
    System.get_env("DOMAIN")
  end

  def pick_template do
    File.ls!(Path.join(:code.priv_dir(:barkbot), "templates"))
    |> Enum.random()
    |> (fn x -> Path.join(:code.priv_dir(:barkbot), "templates/#{x}") end).()
    |> File.read()
    |> elem(1)
  end

  def random_render_tweet(data) do
    ("#{pick_template()} #{domain()}/#{data.url.short}")
    |> Mustache.render(data)
  end
end
