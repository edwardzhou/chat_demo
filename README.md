# Chat
This chat app demostrate how simple is the distribution and concurrency in Elixir's world. 
build a simplified chat room within 30 lines code. and auto-scale to distributed via network transparent.

## clone

```bash
git clone https://github.com/edwardzhou/chat_demo.git
```

## direct run (Elixir should be installed on your system already).
```bash
cd chat_demo/chat
iex --cookie chatting --name chat@localhost -S mix
```

```elixir
{:ok, pid} = Chat.ChatServer.start_link
Chat.ChatServer.add_message(pid, "Edward", "Hi~")
Chat.ChatServer.get_messages(pid)
```


## Run in docker (no need to install Elixir)

### step 1 - build compose and up

```elixir
# open terminal 1
docker-compose up --build


```



### step 2 - open new terminal 2
# list docker containers
```bash
docker ps
```

### should get something like below
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
8f1b075e3895        chatapp_1               "/bin/bash"              9 seconds ago       Up 8 seconds        14000/tcp                host2.com
e2377cff45bb        chatapp_1               "/bin/bash"              9 seconds ago       Up 9 seconds        14000/tcp                host1.com


### step 3 - enter host1.com
```bash
docker exec -it host1.com /bin/bash
iex --cookie chatting --name chat@host1.com -S mix
```

```elixir
{:ok, pid} = Chat.ChatServer.start_link
:global.register_name(:chat_server, pid)
```

### step 4 - open new terminal 3, and enter host2.com
```bash
docker exec -it host2.com /bin/bash
iex --cookie chatting --name chat@host2.com -S mix
```

# establish connection between host1.com and host2.com
```elixir

Node.ping :"chat@host1.com"

# get remote pid from global
rid = :global.whereis_name(:chat_server)

Chat.ChatServer.add_message(rid, "Alex", "Hi~")
Chat.ChatServer.get_messages(rid)
```

### switch back to  terminal 2
```elixir
Chat.ChatServer.get_messages(pid)
> should see messages
```



# check chat/lib/chat/chat_server.ex for detail.
