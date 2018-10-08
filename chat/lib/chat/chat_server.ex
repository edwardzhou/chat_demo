defmodule Chat.ChatServer do
  use GenServer

  # API
  def start_link do
    # __MODULE__ ==> Chat.ChatServer
    GenServer.start_link(__MODULE__, [])
  end

  def add_message(pid, from, message) do
    GenServer.cast(pid, {:add_message, from <> ": " <> message})
  end

  def get_messages(pid) do
    GenServer.call(pid, :get_messages)
  end

  # Server
  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, message}, messages) do
    {:noreply, [message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end

end

"""
### how to experience:
1. in single node
iex -S mix
{:ok, pid} = Chat.ChatServer.start_link
Chat.ChatServer.add_message(pid, "Alex", "Hi~")
Chat.ChatServer.get_messages(pid)
Chat.ChatServer.add_message(pid, "Mike", "Yup excellent~")
Chat.ChatServer.get_messages(pid)

2. distributed
suppose there are two hosts.
host 1, ip 10.21.99.1
host 2, ip 10.21.99.2

# in host 1:
iex --cookie chatting --erl "-kernel inet_dist_listen_min 9000" --erl "-kernel inet_dist_listen_max 9000" --name chat1@10.21.99.1 -S mix

# in host 2:
iex --cookie chatting --erl "-kernel inet_dist_listen_min 9000" --erl "-kernel inet_dist_listen_max 9000" --name chat2@10.21.99.2 -S mix

{:ok, pid} = Chat.ChatServer.start_link
:global.register_name(:chat_server, pid)
Chat.ChatServer.add_message(pid, "Alex", "hi~")
Chat.ChatServer.get_messages(pid)


# in host 1
# retrieve remote process id from global
rid = :global.whereis_name(:chat_server)
Chat.ChatServer.add_message(rid, "Mike", "HI Alex")
Chat.ChatServer.get_messages(rid)


# in host2
Chat.ChatServer.add_message(pid, "Alex", "Excellent~")
Chat.ChatServer.get_messages(pid)

###


# query all registered names
# :global.registered_names

# register pid as :my_name
# :global.register_name(:my_name, pid)


# get remote pid on a remote node from global name
# rid = :global.whereis_name(:my_name)


# send message to remote process
# Chat.ChatServer.get_messages(rid)
# ...
"""
