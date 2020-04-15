defmodule Homer.Component.Media do
  @moduledoc false
  alias __MODULE__

  # @type t 

  defstruct power_state: :off,
            volume: 0

  @callback power_on?(%Media{}) :: boolean
  # @callback turn_on() :: :ok
  # @callback turn_off() :: :ok
  # @callback play_media() :: :ok
  @callback volume_up(%Media{}) :: :ok
  @callback volume_down(%Media{}) :: :ok
  # @callback media_play() :: :ok
  # @callback media_pause() :: :ok
  # @callback media_stop() :: :ok
  # @callback media_next_track() :: :ok
  # @callback media_previous_track() :: :ok
  # @callback clear_playlist() :: :ok
  @callback set_volume_level(%Media{}, non_neg_integer) :: :ok
  # @callback mute_volume() :: :ok
  # @callback media_seek() :: :ok
  # @callback select_source() :: :ok
  # @callback set_shuffle() :: :ok

  # @callback state() :: :ok
  # @callback access_token() :: :ok
  @callback volume_level(%Media{}) :: :ok
  # @callback is_volume_muted() :: :ok
  # @callback media_content_id() :: :ok
  # @callback media_duration() :: :ok
  # @callback media_position() :: :ok
  # @callback media_position_updated_at() :: :ok
  # @callback media_image_url() :: :ok
  # @callback media_image_hash() :: :ok
  # @callback get_media_image() :: :ok
  # @callback media_title() :: :ok
  # @callback media_artist() :: :ok
  # @callback media_album_name() :: :ok
  # @callback media_album_artist() :: :ok
  # @callback media_track() :: :ok
  # @callback media_series_title() :: :ok
  # @callback media_season() :: :ok
  # @callback media_episode() :: :ok
  # @callback media_channel() :: :ok
  # @callback media_playlist() :: :ok
  # @callback app_id() :: :ok
  # @callback source() :: :ok
  # @callback shuffle() :: :ok

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Homer.Component.Media
      alias Homer.Component.Media

      use GenServer

      @doc false
      def start_link(args \\ []) do
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
      end

      defoverridable start_link: 0, start_link: 1

      @impl true
      def init(_args) do
        {:ok, []}
      end

      defoverridable init: 1

      @impl true
      def power_on?(_), do: false

      defoverridable power_on?: 1

      @impl true
      def volume_down(_), do: :ok

      defoverridable volume_down: 1

      @impl true
      def volume_up(_), do: :ok

      defoverridable volume_up: 1

      @impl true
      def set_volume_level(_, _), do: :ok

      defoverridable set_volume_level: 2

      @impl true
      def volume_level(_), do: :ok

      defoverridable volume_level: 1
    end
  end
end
