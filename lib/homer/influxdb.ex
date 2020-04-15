defmodule Homer.InfluxDB do
  @moduledoc """
  Homer InfluxDB
  """
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    Homer.Event.subscribe(:all)
  end

  def handle_info({event, message}, state) do
    # Homer.InfluxDBWriter.measure("qqq", [host:, "laptop", testing: "test"], value: 
    require Logger
    Logger.debug(fn -> "Event #{inspect(event)} #{inspect(message)}" end)
    {:noreply, state}
  end
end
