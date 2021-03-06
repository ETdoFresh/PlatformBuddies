extends Node

signal on_open(client)
signal on_close(client)
signal on_receive(client, message)

var server = WebSocketServer.new()
var clients = []

func _process(_delta):
    server.poll()

func listen(bind_address = "*", port = 11003):
    server.bind_ip = bind_address
    server.private_key = CryptoKey.new(); 
    server.private_key.load("res://keys/privkey.key")
    server.ssl_certificate = X509Certificate.new()
    server.ssl_certificate.load("res://keys/cert.crt")
    server.ca_chain = X509Certificate.new()
    server.ca_chain.load("res://keys/chain.crt")
    server.connect("client_connected", self, "check_for_connection")
    server.connect("client_disconnected", self, "check_for_disconnection")
    server.connect("data_received", self, "check_for_received_data")
    var error = server.listen(port)
    if error:
        print("Error listening on %s:%s. Error Code: %s" % [bind_address, port, error])

func listen_insecure(bind_address = "*", port = 11003):
    server.bind_ip = bind_address
    server.connect("client_connected", self, "check_for_connection")
    server.connect("client_disconnected", self, "check_for_disconnection")
    server.connect("data_received", self, "check_for_received_data")
    var error = server.listen(port)
    if error:
        print("Error listening on %s:%s. Error Code: %s" % [bind_address, port, error])

func send(client, message):
    client.put_packet(message.to_ascii())

func broadcast(message):
    for client in clients:
        send(client, message)

func check_for_connection(id, _protocol):
    var client = server.get_peer(id)
    clients.append(client)
    emit_signal("on_open", client)

func check_for_disconnection(id, _was_clean_close):
    for i in range(clients.size() - 1, -1, -1):
        if clients[i] == server.get_peer(id):
            emit_signal("on_close", clients[i])
            clients.remove(i)

func check_for_received_data(id):
    var client = server.get_peer(id)
    for _i in range(client.get_available_packet_count()):
        var packet = client.get_packet()
        var message = packet.get_string_from_ascii()
        emit_signal("on_receive", client, message)
