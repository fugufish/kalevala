defmodule Kantele.Character.LookView do
  use Kalevala.Character.View

  import IO.ANSI, only: [blue: 0, reset: 0, white: 0]

  def render("look", %{room: room, characters: characters, items: items}) do
    ~E"""
    <%= blue() %><%= room.name %><%= reset() %>
    <%= render("_description", %{room: room}) %>
    <%= render("_items", %{items: items}) %>
    <%= render("_exits", %{room: room}) %>
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

  def render("_characters", %{characters: []}), do: nil

  def render("_characters", %{characters: characters}) do
    characters =
      characters
      |> Enum.map(&render("_character", %{character: &1}))
      |> View.join("\n")

    View.join(["You see:", characters], "\n")
  end

  def render("_character", %{character: character}) do
    ~i(- #{white()}#{character.name}#{reset()})
  end

  def render("_items", %{items: []}), do: nil

  def render("_items", %{items: items}) do
    items =
      items
      |> Enum.map(&render("_item", %{item: &1}))
      |> View.join(", ")

    View.join(["Items:", items], " ")
  end

  def render("_item", %{item: item}) do
    ~i(#{white()}#{item.name}#{reset()})
  end
end