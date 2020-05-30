defmodule CreateTableTest do
  use ExUnit.Case

  alias EctoExtractMigrations.CreateTable

  test "parse_table_name" do
    assert ["foo"] == value(CreateTable.parse_table_name("foo"))
    assert ["foo"] == value(CreateTable.parse_table_name("\"foo\""))
    assert ["foo"] == value(CreateTable.parse_table_name("\"foo\""))
    assert ["public", ?., "foo"] == value(CreateTable.parse_table_name("public.foo"))
    assert ["public", ?., "foo"] == value(CreateTable.parse_table_name("public.\"foo\""))
  end

  test "parse_create_table" do
    assert ["device"] == value(CreateTable.parse("CREATE TABLE device ();"))
    assert ["public", ?., "data_table_974"] == value(CreateTable.parse("CREATE TABLE public.data_table_974 ();"))
    assert ["public", ?., "data_table__tamil__form"] == value(CreateTable.parse("CREATE TABLE public.data_table__tamil__form ();"))
    assert ["public", ?., "device"] == value(CreateTable.parse("CREATE TABLE public.device ();"))
  end

  test "parse_session" do
    sql = """
    CREATE TABLE session (
      uid BYTEA NOT NULL PRIMARY KEY,
      isPersistent BOOLEAN NOT NULL DEFAULT FALSE,
      touched INTEGER
    );
    """
    #  avatar_id INTEGER REFERENCES warp_avatar(id) ON DELETE CASCADE);
    # assert ["device"] == value(CreateTable.parse(sql))
    assert ["device"] == CreateTable.parse(sql)
  end

  test "column" do
    assert [%{name: "uid", null: false, primary_key: true, type: "BYTEA"}] == value(CreateTable.parse_column("uid BYTEA NOT NULL PRIMARY KEY,"))
    assert [%{default: false, name: "isPersistent", null: false, type: "BOOLEAN"}] == value(CreateTable.parse_column("isPersistent BOOLEAN NOT NULL DEFAULT FALSE,"))
    assert [%{default: 0, name: "size", null: false, type: "INTEGER"}] == value(CreateTable.parse_column("size INTEGER NOT NULL DEFAULT 0,"))
  end

  def value({:ok, value, _, _, _, _}), do: value
  def value({:error, value, _, _, _, _}), do: value
end