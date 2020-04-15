defmodule Homer.Supervisor do
  @moduledoc """
  Homer Supervisor
  """
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Homer.Event,
      Homer.Timer,
      Homer.TestSub,
      # Homer.IaqSensor,
      # Homer.InfluxDBWriter,
      # Homer.InfluxDB,
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
