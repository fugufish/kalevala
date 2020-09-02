defmodule Kantele.Character.Commands do
  @moduledoc false

  use Kalevala.Character.Command.Router, scope: Kantele.Character

  module(ChannelCommand) do
    parse("general", :general, fn command ->
      command |> spaces() |> text(:text)
    end)
  end

  module(DelayedCommand) do
    parse("delay", :run, fn command ->
      command |> spaces() |> text(:parse)
    end)
  end

  module(EmoteCommand) do
    parse("emote", :broadcast, fn command ->
      command |> spaces() |> text(:text)
    end)

    parse("emotes", :list)
  end

  module(ItemCommand) do
    parse("drop", :drop, fn command ->
      command |> spaces() |> text(:item_name)
    end)

    parse("get", :get, fn command ->
      command |> spaces() |> text(:item_name)
    end)
  end

  module(InfoCommand) do
    parse("info", :run)
  end

  module(InventoryCommand) do
    parse("i", :run)
    parse("inv", :run)
    parse("inventory", :run)
  end

  module(LookCommand) do
    parse("look", :run)
  end

  module(MoveCommand) do
    parse("north", :north)
    parse("south", :south)
    parse("east", :east)
    parse("west", :west)
    parse("up", :up)
    parse("down", :down)
  end

  module(QuitCommand) do
    parse("quit", :run)
  end

  module(ReloadCommand) do
    parse("recompile", :recompile)
    parse("reload", :reload)
  end

  module(SayCommand) do
    parse("say", :run, fn command ->
      command
      |> spaces()
      |> optional(
        repeat(
          choice([
            symbol("@") |> word(:at) |> spaces(),
            symbol(">") |> word(:adverb) |> spaces()
          ])
        )
      )
      |> text(:text)
    end)
  end

  module(TellCommand) do
    parse("tell", :run, fn command ->
      command
      |> spaces()
      |> word(:name)
      |> spaces()
      |> text(:text)
    end)
  end

  module(VersionCommand) do
    parse("version", :run)
  end

  module(WhisperCommand) do
    parse("whisper", :run, fn command ->
      command
      |> spaces()
      |> word(:name)
      |> spaces()
      |> text(:text)
    end)
  end

  module(WhoCommand) do
    parse("who", :run)
  end

  dynamic(EmoteCommand, :emote, [])
end
