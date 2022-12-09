#!/usr/bin/env elixir

defmodule Day8 do
  def main do
    input = File.read!("day8.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)

    grid =
      input
      |> Enum.map(fn x ->
        x
        |> Enum.map(fn y ->
          String.to_integer(y)
        end)
      end)

    grid_transposed =
      grid
      |> transpose()

    # Part 1
    grid
    |> Enum.with_index()
    |> Enum.map(fn {row, yi} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {height, xi} ->
        visible(grid, grid_transposed, xi, yi, height)
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(&1))
    |> length()
    |> IO.puts()

    # Part 2
    grid
    |> Enum.with_index()
    |> Enum.map(fn {row, yi} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {height, xi} ->
        score(grid, grid_transposed, xi, yi, height)
      end)
    end)
    |> List.flatten()
    |> Enum.max()
    |> IO.puts()
  end

  def score(grid, transpose, x, y, height) do
    size = length(grid)
    horizontal =
      transpose
      |> Enum.at(x)
    vertical =
      grid
      |> Enum.at(y)

    left =
      vertical
      |> Enum.take(x)
      |> Enum.reverse()
      |> visibility_score(height)
    right =
      vertical
      |> Enum.take(-(size-x)+1)
      |> visibility_score(height)
    top =
      horizontal
      |> Enum.take(y)
      |> Enum.reverse()
      |> visibility_score(height)
    bottom =
      horizontal
      |> Enum.take(-(size-y)+1)
      |> visibility_score(height)

    left * right * top * bottom
  end

  def max_index(list, _height) when length(list) == 0 do
    0
  end

  def visibility_score(list, height) do
    higher = list
    |> Enum.find_index(fn x -> x >= height end)
    case higher do
      nil -> length(list)
      _ -> higher + 1
    end
  end

  def visible(grid, transpose, x, y, height) do
    size = length(grid)
    horizontal =
      transpose
      |> Enum.at(x)
    vertical =
      grid
      |> Enum.at(y)
    left =
      vertical
      |> Enum.take(x)
    right =
      vertical
      |> Enum.take(-(size-x-1))
    top =
      horizontal
      |> Enum.take(y)
    bottom =
      horizontal
      |> Enum.take(-(size-y-1))

    height > advent_max(top) || height > advent_max(bottom) || height > advent_max(left) || height > advent_max(right)
  end

  def advent_max(list) when length(list) == 0 do
    # Hack to make a 0 height tree visible
    -1
  end

  def advent_max(list) do
    Enum.max(list)
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end

Day8.main()
