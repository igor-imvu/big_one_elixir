defmodule Timelinex.Block do
  alias Timelinex.RedisPool, as: Redis

  @users_key_postfix "blocked:users"
  @terms_key_postfix "blocked:terms"
  @prefix "user"

  ## Keys

  def blocked_users_key(user_id) do
    "#{@prefix}:#{user_id}:#{@users_key_postfix}"
  end

  def blocked_terms_key(user_id) do
    "#{@prefix}:#{user_id}:#{@terms_key_postfix}"
  end

  ## Actions

  def block(user_id, target_user_id) when is_integer(user_id) and is_integer(target_user_id) do
    Redis.pipeline([["SADD", blocked_users_key(user_id), target_user_id]])
  end

  def block(user_id, term) when is_integer(user_id) and is_binary(term) do
    Redis.pipeline([["SADD", blocked_terms_key(user_id), term]])
  end

  def unblock(user_id, target_user_id) when is_integer(user_id) and is_integer(target_user_id) do
    Redis.pipeline([["SREM", blocked_users_key(user_id), target_user_id]])
  end

  def unblock(user_id, term) when is_integer(user_id) and is_binary(term) do
    Redis.pipeline([["SREM", blocked_terms_key(user_id), term]])
  end

  def blocked_users_by(user_id) do
    {:ok, ids} = Redis.command(["SMEMBERS", blocked_users_key(user_id)])
    ids
  end

  def is_blocked_by_user?(target_user_id, user_id) do
    case Redis.command(["SISMEMBER", blocked_users_key(user_id), target_user_id]) do
      {:ok, 1} -> true
      {:ok, 0} -> false
    end
  end

  def blocked_terms_by(user_id) do
    {:ok, terms} = Redis.command(["SMEMBERS", blocked_terms_key(user_id)])
    terms
  end

  def is_term_blocked_by_user?(term, user_id) do
    case Redis.command(["SISMEMBER", blocked_terms_key(user_id), term]) do
      {:ok, 1} -> true
      {:ok, 0} -> false
    end
  end

end