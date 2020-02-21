defmodule Kantele.SayEvent do
  use Kalevala.Event

  alias Kantele.CommandView
  alias Kantele.SayView

  def interested?(event) do
    match?("rooms:" <> _, event.data.channel_name)
  end

  def echo(conn, event) do
    case event.from_pid == self() do
      true ->
        prompt(conn, CommandView, "prompt", %{})

      false ->
        conn
        |> assign(:character_name, event.data.character.name)
        |> assign(:text, event.data.text)
        |> render(SayView, "listen")
        |> prompt(CommandView, "prompt", %{})
    end
  end
end
