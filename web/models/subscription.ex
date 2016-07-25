defmodule Timelinex.Subscription do
  alias Timelinex.RedisPool, as: Redis

  @outbound_key_postfix "subscription:out"
  @inbound_key_postfix "subscription:in"
  @prefix "user"

  ## Keys

  def out_key(source_id) do
    "#{@prefix}:#{source_id}:#{@outbound_key_postfix}"
  end

  def in_key(target_id) do
    "#{@prefix}:#{target_id}:#{@inbound_key_postfix}"
  end

  ## Actions

  def subscribe(source_id, target_id) when is_integer(source_id) and is_integer(target_id) do
    Redis.pipeline([["SADD", out_key(source_id), target_id], ["SADD", in_key(target_id), source_id]])
  end

  def unsubscribe(source_id, target_id) when is_integer(source_id) and is_integer(target_id) do
    Redis.pipeline([["SREM", out_key(source_id), target_id], ["SREM", in_key(target_id), source_id]])
  end

  def users_subscribed_to(user_id) do
    {:ok, ids} = Redis.command(["SMEMBERS", in_key(user_id)])
    ids
  end

  def subscriptions_of(user_id) do
    {:ok, ids} = Redis.command(["SMEMBERS", out_key(user_id)])
    ids
  end

end