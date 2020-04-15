defmodule Homer.IaqSensor do
  @moduledoc "iAQ Sensor"

  use GenServer
  require Logger

  @default_interval 30

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(arg) do
    interval = Keyword.get(arg, :interval, @default_interval)
    IaqSensor.Supervisor.start_link()
    Homer.Event.subscribe(:time_changed)
    {:ok, interval}
  end

  def handle_info({:time_changed, {{_, _, _}, {_, _, sec}}}, interval) when rem(sec, interval) == 0 do
    ppm = IaqSensor.Device.update()
    Logger.debug fn -> "Event, read iAQ Sensor #{ppm}" end
    Homer.Event.fire(:sensor, "type=\"CO2\",value=#{ppm}")
    {:noreply, interval}
  end

  def handle_info({:time_changed, secs}, interval) when rem(secs, interval) == 0 do
    ppm = IaqSensor.Device.update()
    Logger.debug fn -> "Event, read iAQ Sensor #{ppm}" end
    Homer.Event.fire(:sensor, "type=\"CO2\",value=#{ppm}")
    {:noreply, interval}
  end

  @doc "fallback"
  def handle_info(_, state), do: {:noreply, state}

end
