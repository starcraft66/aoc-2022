#!/usr/bin/env elixir

defmodule Day3 do
  @alphabet Enum.with_index((for n <- ?a..?z, do: << n :: utf8 >>) ++ (for n <- ?A..?Z, do: << n :: utf8 >>),1)
  def main do
    File.read!("day3.txt")
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn s ->
      [h1,h2] = String.graphemes(s)
      |> Enum.chunk_every(div(String.length(s),2))

      # We can also use list subtraction but this is pretty
      dupe = MapSet.intersection(MapSet.new(h1), MapSet.new(h2))
      |> MapSet.to_list
      |> List.first

      {_, priority} = @alphabet
      |> Enum.find(fn {char, _index} -> char == dupe end)

      priority
    end)
    |> Enum.sum
    |> IO.puts
  end
end

Day3.main
