extends Node2D

var tick = 0
var send_rate = 1 # Ticks (- 1) between sending input

var characters = []

onready var websocket = $Websocket
onready var level1 = $Level1
onready var input = $KeyboardInput

func _ready():
    randomize()
    websocket.connect("on_receive", self, "update_world")
    websocket.open()

func _physics_process(delta):
    tick += 1
    input.simulate(delta)
    if tick % send_rate == 0:
        websocket.send(to_json(input.to_dictionary()))

func update_world(message):
    from_dictionary(parse_json(message))

func from_dictionary(dictionary):
    while characters.size() < dictionary.characters.size():
        var character = level1.spawn_random_character(null)
        character.collision_layer = 2
        character.collision_mask = 2
        characters.append(character)
    while characters.size() > dictionary.characters.size():
        characters[characters.size() - 1].queue_free()
        characters.remove(characters.size() - 1)
    for i in range(characters.size()):
        characters[i].from_dictionary(dictionary.characters[i])
