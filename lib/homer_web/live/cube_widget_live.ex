defmodule HomerWeb.Live.Widget.Cube do
  use Phoenix.LiveView

  def render(assigns) do
    # var el = document.getElementsByClassName("kuben__scene")[0]
    ~L"""
    <div class="kuben__scene" phx-click="rotate">
      <script>
        function calcKubenSize() {
          var el = document.getElementById("<%= @socket.id %>")
          el.style.setProperty("--kubenheight", el.clientHeight + "px")
          el.style.setProperty("--kubenwidth", el.clientWidth + "px")
          console.log(el.clientHeight)
          console.log(el.clientWidth)
        }
        window.addEventListener("resize", calcKubenSize);
        calcKubenSize();
      </script>
      <div class="kuben show-<%= @side %>">
        <div class="kuben__face kuben__face--front">front</div>
        <div class="kuben__face kuben__face--back">back</div>
        <div class="kuben__face kuben__face--right">right</div>
        <div class="kuben__face kuben__face--left">left</div>
        <%# <div class="kuben__face kuben__face--top">top</div> %>
        <%# <div class="kuben__face kuben__face--bottom">bottom</div> %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(3000, self(), :rotate)

    {:ok,
     assign(socket,
       side: "front",
       sides: ["left", "back", "right"]
     )}
  end

  def handle_event("rotate", _value, socket) do
    socket = rotate_left(socket)

    {:noreply, socket}
  end

  def handle_info(:rotate, socket) do
    socket = rotate_left(socket)

    {:noreply, socket}
  end

  defp rotate_left(socket) do
    side = socket.assigns.side
    sides = socket.assigns.sides

    assign(socket,
      side: hd(sides),
      sides: tl(sides) ++ [side]
    )
  end
end
