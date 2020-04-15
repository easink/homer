defmodule HomerWeb.Live.Widget.Clock do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="clock">
      <div class="clock-label">SEIKO</div>
      <div class="clock-hourhand" style="transform: rotate(<%= @hour_deg %>deg);"></div>
      <div class="clock-minutehand" style="transform: rotate(<%= @min_deg %>deg);"></div>
      <div class="clock-secondhand" style="transform: rotate(<%= @sec_deg %>deg);"></div>
      <div class="clock-hour12"></div>
      <div class="clock-hour1"></div>
      <div class="clock-hour2"></div>
      <div class="clock-hour3"></div>
      <div class="clock-hour4"></div>
      <div class="clock-hour5"></div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok,
     assign(socket,
       title: "Title",
       clock: DateTime.utc_now(),
       hour_deg: 0,
       min_deg: 0,
       sec_deg: 0
     )}
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, clock_position())
    {:noreply, assign(socket, clock: DateTime.utc_now())}
  end

  def clock_position() do
    {_, {hour, minute, second}} = :calendar.local_time()
    hour = hour |> rem(12)
    hour_deg = 360 / 12 * hour + 270
    min_deg = 360 / 60 * minute + 270
    sec_deg = 360 / 60 * second + 270
    [hour_deg: hour_deg, min_deg: min_deg, sec_deg: sec_deg]
  end

  # def handle_event("inc", _, socket) do
  #   if socket.assigns.val >= 75, do: raise("boom")
  #   {:noreply, update(socket, :val, &(&1 + 1))}
  # end
end
