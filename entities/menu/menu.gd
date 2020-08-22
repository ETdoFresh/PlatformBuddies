extends Control

const local_world = preload("res://entities/world/local.tscn")
const server_world = preload("res://entities/world/server.tscn")
const client_world = preload("res://entities/world/client.tscn")
const both_worlds = preload("res://entities/world/both.tscn")

func _ready():
    var _1 = $VBoxContainer/Button.connect("pressed", self, "load_scene", [local_world])
    var _2 = $VBoxContainer/Button2.connect("pressed", self, "load_scene", [server_world])
    var _3 = $VBoxContainer/Button3.connect("pressed", self, "load_scene", [client_world])
    var _4 = $VBoxContainer/Button4.connect("pressed", self, "load_scene", [both_worlds])
    
    var _10 = $LineEdit.connect("text_changed", self, "update_client_url")

func load_scene(scene):
    var _1 = get_tree().change_scene_to(scene)

func update_client_url(url):
    Settings.client_url = url
