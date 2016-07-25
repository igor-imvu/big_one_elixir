defmodule Timelinex.Chronicler.Personal do
  def start_link(post, author_id, owner) do
    Task.start_link(__MODULE__, :record, [post, author_id, owner])
  end

  def record(post, author_id, _owner) do
    Timelinex.Timeline.add_to_personal(author_id, post)
  end

end