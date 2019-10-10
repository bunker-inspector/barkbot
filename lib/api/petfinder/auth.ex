defmodule Api.Petfinder.Auth do
  @api_base "https://api.petfinder.com/v2/oauth2/token"

  defmacro api_key do
    System.get_env("PETFINDER_API_KEY")
  end

  defmacro client_secret do
    System.get_env("PETFINDER_SECRET")
  end

  def header do
    %{authorization: "Bearer #{access_token()}"}
  end

  def access_token do
    t = Util.get_table(:api)
    case :ets.lookup(t, :access_token) do
      [] ->
        refresh_token()
      [access_token: {ts, token}] ->
        now = Util.now()
        if now > ts do
          refresh_token()
        else
          token
        end
    end
  end

  def refresh_token do
    {:ok, body} = Jason.encode(%{grant_type: "client_credentials",
                                 client_id: api_key(),
                                 client_secret: client_secret()})

    case HTTPotion.post(@api_base, body: body) do
      %HTTPotion.Response{:body => new_key} ->
        foo = Jason.decode(new_key)
        case foo  do
          {:ok, %{"access_token" => access_token,
                   "expires_in" => expires_in}} ->
            t = Util.get_table(:api)
            :ets.insert(t, {:access_token, {Util.now() + expires_in, access_token}})
            access_token
          _ ->
            nil
        end
      _ ->
        nil
    end
  end
end
