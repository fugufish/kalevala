defmodule Kantele.LookView do
  use Kalevala.View

  import IO.ANSI, only: [blue: 0, reset: 0, white: 0]

  def render("look", %{room: room, characters: characters}) do
    ~E"""
    <%= blue() %><%= room.name %><%= reset() %>
    <%= render("_description", %{room: room}) %>
    <%= render("_exits", %{room: room}) %>

    You see:
    <%= render("_characters", %{characters: characters}) %>
    """
  end

  def render("_description", %{room: room}) do
    features =
      Enum.map(room.features, fn feature ->
        feature.short_description
      end)

    View.join([room.description] ++ features, " ")
  end

  def render("_exits", %{room: room}) do
    exits =
      room.exits
      |> Enum.map(fn room_exit ->
        ~i(#{white()}#{room_exit.exit_name}#{reset()})
      end)
      |> View.join(" ")

    View.join(["Exits:", exits], " ")
  end

  def render("_characters", %{characters: characters}) do
    characters
    |> Enum.map(&render("_character", %{character: &1}))
    |> View.join("\n")
  end

  def render("_character", %{character: character}) do
    ~i(- #{white()}#{character.name}#{reset()})
  end
end