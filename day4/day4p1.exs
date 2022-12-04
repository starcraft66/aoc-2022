#!/usr/bin/env elixir

defmodule Day4 do
  def main do
    File.read!("day4.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s ->
      [r1, r2] = String.split(s, ",")
      |> Enum.map(fn ss ->
        [first, last] = String.split(ss, "-")
        String.to_integer(first)..String.to_integer(last)
      end)
      (MapSet.subset?(MapSet.new(Enum.to_list(r1)), MapSet.new(r2))
      or MapSet.subset?(MapSet.new(Enum.to_list(r2)), MapSet.new(r1)))
    end)
    |> Enum.map(fn result ->
      case result do
        true -> 1
        _ -> 0
      end
    end)
    |> Enum.sum
    |> IO.puts
  end
end

Day4.main()
