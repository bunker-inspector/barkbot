defmodule Mix.Tasks.Project do
  defmodule Version do
    use Mix.Task

    def run(_) do
      IO.puts Mix.Project.config[:version] 
    end
  end
end

defmodule Mix.Tasks.Template do
  defmodule Create do
    use Mix.Task

    def run(_) do
      fname = "templates/" <> Integer.to_string(Util.now()) <> ".txt"
      case File.touch Path.join(:code.priv_dir(:barkbot), fname) do
        :ok ->
          IO.puts "ok"
        _  ->
          IO.puts "error"
      end
    end
  end
end
