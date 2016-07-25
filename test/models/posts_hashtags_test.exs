defmodule Timelinex.PostsHashtagsTest do
  use Timelinex.ModelCase

  alias Timelinex.PostsHashtags

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostsHashtags.changeset(%PostsHashtags{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostsHashtags.changeset(%PostsHashtags{}, @invalid_attrs)
    refute changeset.valid?
  end
end
