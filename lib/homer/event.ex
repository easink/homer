defmodule Homer.Event do
  @moduledoc """
  Documentation for Homer.Event.
  """
  use GenServer

  @registry Registry.Event

  @doc """


  ## Examples

      iex> Homer.Event.start_link()
      iex> Homer.Event.subscribe(:test_event)
      iex> Homer.Event.fire(:test_event, "message")
      iex> receive do x -> x end
      {:test_event, "message"}

  """
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Registry.start_link(keys: :duplicate, name: @registry)
    {:ok, []}
  end

  # API

  def fire(event, value) do
    GenServer.cast(__MODULE__, {event, value})
  end

  def subscribe(event) do
    Registry.register(@registry, event, [])
  end

  # callbacks

  def handle_cast({event, value}, state) do
    broadcast(event, value)
    {:noreply, state}
  end

  # privates

  defp broadcast(event, message) do
    Registry.dispatch(@registry, event, fn entries ->
      for {pid, _} <- entries, do: send(pid, {event, message})
    end)

    # send to :all watcher
    Registry.dispatch(@registry, :all, fn entries ->
      for {pid, _} <- entries, do: send(pid, {event, message})
    end)
  end

end
