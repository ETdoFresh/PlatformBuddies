extends Node2D

const CHARACTERS = [
    preload("res://entities/character/character.tscn"),
    preload("res://entities/character/character2.tscn"),
    preload("res://entities/character/character3.tscn"),
    preload("res://entities/character/character4.tscn"),]

func spawn_random_character(input):
    var random_i = randi() % CHARACTERS.size()
    var character = CHARACTERS[random_i].instance()
    character.position = $Spawn.get_random_spawn().position
    character.input = input if input else character.input
    add_child(character)
    return character

func simulate(delta):
    for child in get_children():
        if child.has_method("simulate"):
            child.simulate(delta)
