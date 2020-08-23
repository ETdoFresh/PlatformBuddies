extends Node2D

const NETWORK_INPUT = preload("res://entities/network_input/network_input.tscn")

var tick = 0
var players = {}
var send_rate = 1 # Ticks (- 1) between sending input

onready var websocket = $Websocket
onready var level1 = $Level1

func _ready():
    randomize()
    websocket.connect("on_open", self, "create_player")
    websocket.connect("on_close", self, "remove_player")
    websocket.connect("on_receive", self, "update_input")
    if get_parent() == get_tree().get_root():
        websocket.listen()
    else:
        websocket.listen_insecure()

func _physics_process(delta):
    tick += 1
    for player in players.values():
        player.input.simulate(delta)
    level1.simulate(delta)
    
    if tick % send_rate == 0:
        websocket.broadcast(to_json(to_dictionary()))

func create_player(client):
    var input = NETWORK_INPUT.instance()
    add_child(input)
    var character = level1.spawn_random_character(input)
    var player = {"input": input, "character": character, "host": client.get_connected_host(), "port": client.get_connected_port()}
    players[client] = player
    console_write_ln("A Client has connected! %s:%s" % [player.host, player.port])

func remove_player(client):
    var player = players[client]
    player.input.queue_free()
    player.character.queue_free()
    console_write_ln("A Client has disconnected! %s:%s" % [player.host, player.port])
    players.erase(client)

func update_input(client, message):
    players[client].input.from_dictionary(parse_json(message))

func to_dictionary():
    var characters = []
    for player in players.values():
        characters.append(player.character.to_dictionary())
    return {"characters": characters}

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
