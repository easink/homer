defmodule HomerWeb.Live.Widget.Clock2 do
  use Phoenix.LiveView

  def render(assigns) do
    # <div class="sec-hand" style="transform: rotate(<%= @sec_deg %>deg);"></div>
    # <div class="sec-hand" style="--clocksecdeg: <%= @sec_deg %>"></div>
    ~L"""
    <div class="clock" phx-click="github_deploy">
      <div class="clock-dot"></div>
      <div class="clock-sec-hand" style="--clocksecdeg: <%= @sec_deg %>deg"></div>
      <div class="clock-sec-hand shadow" style="--clocksecdeg: <%= @sec_deg %>deg"></div>
      <div class="clock-min-hand" style="--clockmindeg: <%= @min_deg %>deg"></div>
      <div class="clock-min-hand shadow" style="--clockmindeg: <%= @min_deg %>deg"></div>
      <div class="clock-hour-hand" style="--clockhourdeg: <%= @hour_deg %>deg"></div>
      <div class="clock-hour-hand shadow" style="--clockhourdeg: <%= @hour_deg %>deg"></div>
      <span class="clock-twelve">12</span>
      <span class="clock-three">3</span>
      <span class="clock-six">6</span>
      <span class="clock-nine">9</span>
      <%= for i <- 0..59 do %>
        <span class="clock-lines" style="--diallinedeg: <%= i*6 %>deg"></span>
      <% end %>
      <div class="clock-date"><%= @day %></div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :tick)

    {:ok,
     assign(socket,
       title: "Title",
       clock: DateTime.utc_now(),
       day: 0,
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
    {{_year, _month, day}, {hour, minute, second}} = :calendar.local_time()
    hour = hour |> rem(12)
    hour_deg = 30 * (hour + minute / 60)
    min_deg = 6 * minute
    sec_deg = 6 * second
    [day: day, hour_deg: hour_deg, min_deg: min_deg, sec_deg: sec_deg]
  end

  # def handle_event("inc", _, socket) do
  #   if socket.assigns.val >= 75, do: raise("boom")
  #   {:noreply, update(socket, :val, &(&1 + 1))}
  # end
end
