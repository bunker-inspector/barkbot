defmodule Util do
  def now(), do: DateTime.utc_now() |> DateTime.to_unix()

  def get_table(table) do
    case :ets.whereis(table) do
      :undefined -> :ets.new(table, [:named_table])
      t -> t
    end
  end
end
