#!/usr/bin/env elixir

defmodule Day6 do
  def main do
    File.read!("day6.txt")
    |> String.split("\n", trim: true)
    |> List.first()
    |> String.graphemes()
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.with_index(4)
    |> Enum.reduce([], fn {x, index}, acc ->
      if has_duplicates?(x), do: acc, else: [ index | acc]
    end)
    |> List.last()
    |> IO.inspect()
  end

  defp has_duplicates?(list), do: length(Enum.uniq(list)) != length(list)
end

Day6.main()
