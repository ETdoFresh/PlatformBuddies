extends Node2D

onready var input = $KeyboardInput
onready var level1 = $Level1

func _ready():
    randomize()
    level1.spawn_random_character(input)

func _physics_process(delta):
    input.simulate(delta)
    level1.simulate(delta)
