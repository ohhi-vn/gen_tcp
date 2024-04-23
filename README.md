# Gen_tcp

## First Example

Both Client and Server is run on Elixir service.

Uncomment 2 lines in application.ex:
```elixir
       %{id: GenTcp.Server, start: {GenTcp.Server, :start_link, [[]]}},
       %{id: GenTcp.Client, start: {GenTcp.Client, :start_link, [[]]}}
```

Start the server by command: `iex -S server`

Run these command:
```elixir
alias GenTcp.Client
Client.send_to_server("Hello")
Client.close_socket()
```

## Second Example

Client is run on Elixir service, Server is run on Python service.

Comment 2 lines in application.ex:
```elixir
       %{id: GenTcp.Server, start: {GenTcp.Server, :start_link, [[]]}},
       %{id: GenTcp.Client, start: {GenTcp.Client, :start_link, [[]]}}
```

Terminal 1:

Start the server by command: `iex -S server`

Run these commands to simulate the client-server:

```elixir
alias GenTcp.ServerInteracPy
ServerInteracPy.start_server()
```

Terminal 2:

Run these commands:

```elixir
cd lib/gen_tcp
python3 client_py.py
```