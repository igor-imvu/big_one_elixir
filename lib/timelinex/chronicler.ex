defmodule Timelinex.Chronicler do

  def start_link(recorder, post, for_user_id, owner, _opts \\ []) do
    recorder.start_link(post, for_user_id, owner)
  end

  def record(post) do
    Supervisor.start_child(Timelinex.Chronicler.Supervisor, [Timelinex.Chronicler.Personal, post, post.author_id, self()])

    Timelinex.Subscription.users_subscribed_to(post.author_id)
    |> Enum.map(&Supervisor.start_child(Timelinex.Chronicler.Supervisor, [Timelinex.Chronicler.Public, post, &1, self()]))
  end

end