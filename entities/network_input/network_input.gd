class_name NetworkInput
extends Node

var client # Testing if reference causes websocket issue
var x = 0
var jump = false
var was_jump = false
var start_jump = false
var stop_jump = false

func _init(init_client):
    client = init_client

func simulate(_delta):
    if jump:
        if not was_jump:
            start_jump = true
        else:
            start_jump = false
        was_jump = true
    else:
        if was_jump:
            stop_jump = true
        else:
            stop_jump = false
        was_jump = false

func from_dictionary(dictionary):
    if "x" in dictionary: x = dictionary.x
    if "jump" in dictionary: jump = dictionary.jump
