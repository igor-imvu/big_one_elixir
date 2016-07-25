defmodule Timelinex.Chronicler.Public do
  alias Timelinex.{Timeline, Block}

  def start_link(post, user_id, owner) do
    Task.start_link(__MODULE__, :record, [post, user_id, owner])
  end

  def record(post, user_id, _owner) do
    if !blocked?(post, user_id) do
      Timeline.add_to_public(user_id, post)
    end
  end

  def blocked?(post, user_id) do
    Block.is_blocked_by_user?(post.author_id, user_id) ||
      String.split(post.content, " ")
      |> Enum.any?(&Block.is_term_blocked_by_user?(&1, user_id))
  end
end