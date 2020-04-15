defmodule HomerEventTest do
  use ExUnit.Case

  test "subscribe timer event" do
    Homer.Event.subscribe(:time_changed)
    assert_receive({:event, :time_changed, _}, 1_000)
  end

end
