defmodule Kantele.Character.LoginController do
  use Kalevala.Character.Controller

  require Logger

  alias Kantele.Character.ChannelEvent
  alias Kantele.Character.CharacterView
  alias Kantele.Character.CommandController
  alias Kantele.Character.LoginView
  alias Kantele.Character.MoveEvent
  alias Kantele.Character.MoveView
  alias Kantele.Character.QuitView

  @impl true
  def init(conn) do
    conn
    |> put_session(:login_state, :username)
    |> render(LoginView, "welcome", %{})
    |> prompt(LoginView, "name", %{})
  end

  @impl true
  def recv(conn, ""), do: conn

  def recv(conn, data) do
    case get_session(conn, :login_state) do
      :username ->
        process_username(conn, data)

      :password ->
        process_password(conn, data)

      :character ->
        process_character(conn, data)
    end
  end

  defp process_username(conn, data) do
    name = String.trim(data)

    case name do
      "" ->
        prompt(conn, LoginView, "name", %{})

      <<4>> ->
        conn
        |> prompt(QuitView, "goodbye", %{})
        |> halt()

      "quit" ->
        conn
        |> prompt(QuitView, "goodbye", %{})
        |> halt()

      name ->
        conn
        |> put_session(:login_state, :password)
        |> put_session(:username, name)
        |> send_option(:echo, true)
        |> prompt(LoginView, "password", %{})
    end
  end

  defp process_password(conn, _data) do
    name = get_session(conn, :username)

    Logger.info("Signing in \"#{name}\"")

    conn
    |> put_session(:login_state, :character)
    |> send_option(:echo, false)
    |> render(LoginView, "signed-in", %{})
    |> prompt(LoginView, "character-name", %{})
  end

  defp process_character(conn, character_name) do
    character =
      character_name
      |> String.trim()
      |> build_character()

    conn
    |> put_session(:login_state, :authenticated)
    |> put_character(character)
    |> render(CharacterView, "vitals", %{})
    |> move(:to, character.room_id, MoveView, "enter", %{})
    |> subscribe("rooms:#{character.room_id}", [], &MoveEvent.subscribe_error/2)
    |> subscribe("general", [], &ChannelEvent.subscribe_error/2)
    |> render(LoginView, "enter-world", %{})
    |> put_controller(CommandController)
    |> event("room/look", %{})
  end

  defp build_character(name) do
    starting_room_id =
      Kantele.Config.get([:player, :starting_room_id])
      |> Kantele.World.dereference()

    %Kalevala.Character{
      id: name,
      pid: self(),
      room_id: starting_room_id,
      name: name,
      status: "#{name} is here.",
      description: "#{name} is a person.",
      inventory: [
        %Kalevala.World.Item.Instance{
          id: Kalevala.World.Item.Instance.generate_id(),
          item_id: "global:potion",
          created_at: DateTime.utc_now(),
          callback_module: Kantele.World.Item.Instance
        }
      ],
      meta: %Kantele.Character.PlayerMeta{
        vitals: %Kantele.Character.Vitals{
          health_points: 25,
          max_health_points: 25,
          skill_points: 17,
          max_skill_points: 17,
          endurance_points: 30,
          max_endurance_points: 30
        }
      }
    }
  end
end