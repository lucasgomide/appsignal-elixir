defmodule Appsignal.SystemBehaviour do
  @callback root?() :: boolean()
  @callback heroku?() :: boolean()
  @callback uid() :: integer | nil
end

defmodule Appsignal.System do
  @behaviour Appsignal.SystemBehaviour

  def heroku? do
    System.get_env("DYNO") != nil
  end

  def root? do
    uid() == 0
  end

  def uid do
    case System.cmd("id", ["-u"]) do
      {id, _} ->
        case Integer.parse(List.first(String.split(id, "\n"))) do
          {int, _} -> int
          :error -> nil
        end
      _ -> nil
    end
  end
end
