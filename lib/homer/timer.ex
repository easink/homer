defmodule Homer.Timer do
  @moduledoc """
  Timer module
  """
  use Task
  alias Homer.Event
  require Logger

  @default_interval 1_000

  #
  # API
  #

  def start_link(_args) do
    Task.start_link(__MODULE__, :start_timer, [@default_interval])
  end

  def start_timer(interval) do
    Logger.debug fn -> "[I] start_timer with #{interval} interval." end
    timer(interval)
    # :timer.apply_interval(interval, __MODULE__, :fire, [])
    # Process.sleep(:infinity)
  end

  #
  # Privates
  #

  defp timer(interval) do
    time = Time.utc_now()
    {micro_sec, _} = time.microsecond
    diff = 1_000 - div(micro_sec, 1_000)
    Process.send_after(self(), :fire, diff)
    receive do
      :fire -> fire()
    end
    timer(interval)
  end

  def fire do
    now = DateTime.utc_now()

    value = now |> DateTime.to_naive() |> NaiveDateTime.to_erl
    Event.fire(:time_changed, value)

    secs = now |> DateTime.to_unix
    Event.fire(:time_changed, secs)
    # Logger.debug fn -> "[I] Fire 'event_time_changed'" end
  end

end
