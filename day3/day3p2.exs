#!/usr/bin/env elixir

defmodule Day3 do
  @alphabet Enum.with_index((for n <- ?a..?z, do: << n :: utf8 >>) ++ (for n <- ?A..?Z, do: << n :: utf8 >>),1)
  def main do
    File.read!("day3.txt")
    |> String.trim
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(fn s ->
      [t1,t2,t3] = Enum.map(s, fn x -> String.graphemes(x) end)

      # We can also use list subtraction but this is pretty
      dupe = MapSet.intersection(MapSet.new(t1), MapSet.new(t2))
      |> MapSet.intersection(MapSet.new(t3))
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
