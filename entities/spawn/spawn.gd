extends Node2D

func _ready():
    for child in get_children():
        child.visible = false

func get_random_spawn():
    var random_i = randi() % get_child_count()
    return get_child(random_i)
