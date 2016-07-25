defmodule Timelinex.HashtagTest do
  use Timelinex.ModelCase

  alias Timelinex.Hashtag

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Hashtag.changeset(%Hashtag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Hashtag.changeset(%Hashtag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
