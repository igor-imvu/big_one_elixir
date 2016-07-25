defmodule Timelinex.Timeline do
  alias Timelinex.RedisPool, as: Redis

  @public_key_postfix "public_timeline"
  @personal_key_postfix "personal_timeline"
  @prefix "user"

  @max_posts_in_public 500
  @max_posts_in_personal 500

  ## Keys

  def public_timline_key(user_id) do
    "#{@prefix}:#{user_id}:#{@public_key_postfix}"
  end

  def personal_timline_key(user_id) do
    "#{@prefix}:#{user_id}:#{@personal_key_postfix}"
  end

  ## Actions

  def add_to_public(user_id, post) do
    case Redis.command(["LPUSH", public_timline_key(user_id), post.id]) do
      {:ok, count} when count > @max_posts_in_public ->
        Redis.command(["RPOP", public_timline_key(user_id)])
      _ -> :ok
    end
  end

  def add_to_personal(user_id, post) do
    case Redis.command(["LPUSH", personal_timline_key(user_id), post.id]) do
      {:ok, count} when count > @max_posts_in_personal ->
        Redis.command(["RPOP", personal_timline_key(user_id)])
      _ -> :ok
    end
  end


  def public(user_id, start \\ 0, stop \\ -1) when is_integer(user_id) do
    Redis.command(["LRANGE", public_timline_key(user_id), start, stop])
  end

  def personal(user_id, start \\ 0, stop \\ -1) when is_integer(user_id) do
    Redis.command(["LRANGE", personal_timline_key(user_id), start, stop])
  end

end