defmodule Weather.TableFormatter do
  @moduledoc false

  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]
  import Record
  defrecord(:xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  def print_table_by_xpaths(xmldoc, fields) do
    with data_by_columns <- split_into_columns(xmldoc, fields),
         column_widths <- widths_of(data_by_columns),
         format <- format_for(column_widths) do
      column_widths |> separator() |> IO.puts()
      data_by_columns |> puts_in_columns(format)
      column_widths |> separator() |> IO.puts()
    end
  end

  def extract_value_from_xmldoc(xmldoc, xpath) do
    xpath
    |> String.to_charlist()
    |> :xmerl_xpath.string(xmldoc)
    |> map(&xmlText(&1, :value))
    |> to_string()
  end

  def split_into_columns(xmldoc, fields) do
    with {labels, paths} <- Enum.unzip(fields) do
      [
        labels |> map(&Atom.to_string/1),
        paths |> map(&extract_value_from_xmldoc(xmldoc, &1))
      ]
    end
  end

  def widths_of(data_by_columns) do
    for column <- data_by_columns, do: column |> map(&String.length/1) |> max()
  end

  def format_for(column_widths) do
    "| " <> map_join(column_widths, " | ", &("~-#{&1}s")) <> " |~n"
  end

  def separator(column_widths) do
    "+-" <> map_join(column_widths, "---", &(List.duplicate("-", &1))) <> "-+"
  end

  def puts_in_columns(columns, format) do
    columns
    |> List.zip()
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(columns, format) do
    :io.format(format, columns)
  end
end
