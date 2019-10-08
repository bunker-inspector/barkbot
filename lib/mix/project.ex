defmodule Mix.Tasks.Project do
  defmodule Version do
    use Mix.Task

    def run(_) do
      IO.puts Mix.Project.config[:version] 
    end
  end
end
