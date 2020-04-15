defmodule HomerWeb.Live.Widget.UnlimitedCube do
  use Phoenix.LiveView

  def render(assigns) do
    #
    # one side has a phoenix-hook
    #
    transition_time = if assigns.reset, do: "0s", else: "1s"
    clickable_right = if assigns.clickable, do: "phx-click=rotate_right", else: ""
    clickable_left = if assigns.clickable, do: "phx-click=rotate_left", else: ""

    ~L"""
    <div class="ucube__scene">
      <div class="ucube overlay-left" <%= clickable_left %> ></div>
      <div class="ucube overlay-right" <%= clickable_right %> ></div>
      <script>
        function calcUnlimitedCubeSize() {
          var el = document.getElementById("<%= @socket.id %>")
          el.style.setProperty("--ucubeheight", el.clientHeight + "px")
          el.style.setProperty("--ucubewidth", el.clientWidth + "px")
          console.log(el.clientHeight)
          console.log(el.clientWidth)
        }
        window.addEventListener("resize", calcUnlimitedCubeSize);
        calcUnlimitedCubeSize();

      </script>
      <div class="ucube">
        <div class="ucube__face" style="transform: rotateY(<%= @angle - 90 %>deg) translateZ(calc(var(--ucubewidth) / 2)); transition: transform <%= transition_time %>"><%= @left %></div>
        <div class="ucube__face" style="transform: rotateY(<%= @angle      %>deg) translateZ(calc(var(--ucubewidth) / 2)); transition: transform <%= transition_time %>" phx-hook="UnlimitedCube"><%= @front %></div>
        <div class="ucube__face" style="transform: rotateY(<%= @angle + 90 %>deg) translateZ(calc(var(--ucubewidth) / 2)); transition: transform <%= transition_time %>"><%= @right %></div>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    # if connected?(socket), do: :timer.send_interval(2000, self(), :rotate_left)

    sides = Map.get(session, "sides", ["Empty"])

    socket =
      socket
      |> assign(sides: sides)
      |> assign(rotation: :none)
      |> justify()

    {:ok, socket}
  end

  def handle_event("rotate_right", _value, socket),
    do: {:noreply, rotate_right(socket)}

  def handle_event("rotate_left", _value, socket),
    do: {:noreply, rotate_left(socket)}

  def handle_event("transitionend", _value, socket),
    do: {:noreply, justify(socket)}

  def handle_info(:rotate_left, socket),
    do: {:noreply, rotate_left(socket)}

  def handle_info(:rotate_right, socket),
    do: {:noreply, rotate_right(socket)}

  defp justify(socket) do
    sides = socket.assigns.sides

    new_sides =
      case socket.assigns.rotation do
        :right ->
          [last | rest] = Enum.reverse(sides)
          [last | Enum.reverse(rest)]

        :left ->
          tl(sides) ++ [hd(sides)]

        :none ->
          sides
      end

    [front, right] = new_sides |> Stream.cycle() |> Enum.take(2)

    socket
    |> assign(sides: new_sides)
    |> assign(front: front)
    |> assign(right: right)
    |> assign(left: List.last(new_sides))
    |> assign(angle: 0)
    |> assign(rotation: :none)
    |> assign(clickable: true)
    |> assign(reset: true)
  end

  defp rotate_left(socket) do
    socket
    |> assign(angle: socket.assigns.angle - 90)
    |> assign(reset: false)
    |> assign(clickable: false)
    |> assign(rotation: :left)
  end

  defp rotate_right(socket) do
    socket
    |> assign(angle: socket.assigns.angle + 90)
    |> assign(reset: false)
    |> assign(clickable: false)
    |> assign(rotation: :right)
  end
end
