defmodule Homer.TestSub do
  @moduledoc "Test subscription"

  use GenServer
  require Logger

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Homer.Event.subscribe(:time_changed)
  end

  def handle_info({:time_changed, secs} = value, state) when is_integer(secs) do
    Logger.debug(fn -> "Got event :time_changed with value #{inspect(value)}" end)
    {:noreply, state}
  end

  def handle_info({:time_changed, {_, {_, _, 0}}} = value, state) do
    Logger.debug(fn -> "Got event :time_changed with value #{inspect(value)}" end)
    {:noreply, state}
  end

  def handle_info({:time_changed, {_, {_, _, qqq}}} = value, state) when rem(qqq, 5) == 0 do
    Logger.debug(fn ->
      "Get event every five seconds :time_changed with value #{inspect(value)}"
    end)

    {:noreply, state}
  end

  @doc "fallback"
  def handle_info(_, state), do: {:noreply, state}
end
