extends Node

const CONNECTED = WebSocketClient.CONNECTION_CONNECTED

signal on_open()
signal on_close()
signal on_receive(message)
signal on_send(message)

var client = WebSocketClient.new()
var client_peer
var connected = false

func _process(_delta):
    client.poll()

func open(url = "ws://localhost:11003"):
    if url.to_lower().begins_with("wss") &&  OS.get_name() != "HTML5":
        client.trusted_ssl_certificate = X509Certificate.new()
        client.trusted_ssl_certificate.load("res://keys/chain.crt")
        client.verify_ssl = true
    client.connect("connection_established", self, "check_for_connection")
    client.connect("connection_closed", self, "check_for_disconnection")
    client.connect("data_received", self, "check_for_received_data")
    client.connect("connection_error", self, "print_connection_error")
    var error = client.connect_to_url(url)
    if error:
        print("Error connecting to %s. Error Code: %s" % [url, error])

func send(message):
    if client and client.get_connection_status() == CONNECTED:
        client_peer.put_packet(message.to_ascii())
        emit_signal("on_send", message)

func check_for_connection(_protocol):
    emit_signal("on_open")
    client_peer = client.get_peer(1)

func check_for_disconnection(_was_clean_close):
    emit_signal("on_close")

func check_for_received_data():
    for _i in range(client_peer.get_available_packet_count()):
        var packet = client_peer.get_packet()
        var message = packet.get_string_from_ascii()
        emit_signal("on_receive", message)

func print_connection_error():
    print("Error connecting to server.")
