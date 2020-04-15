defmodule Homer do
  @moduledoc """
  Homer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Application

  def start(_type, _args) do
    Homer.Supervisor.start_link()
  end

  def components() do
    # Homer.IaqSensor.start_link()
  end
end
