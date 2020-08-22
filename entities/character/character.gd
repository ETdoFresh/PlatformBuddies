extends KinematicBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var input = {"x": 0, "start_jump": false, "stop_jump": false}

var linear_velocity = Vector2.ZERO
var max_linear_velocity = 600
var movement_force = 10000
var jump_force = 1600
var gravity_multiplier = 5000
var friction = 0.5
var air_resistance = 0.1

onready var sprite = $Sprite

func simulate(delta):
    linear_velocity += gravity * gravity_multiplier * delta
    
    if input.x != 0:
        linear_velocity.x += input.x * movement_force * delta
        linear_velocity.x = clamp(linear_velocity.x, -max_linear_velocity, max_linear_velocity)
        if input.x < 0:
            sprite.flip_h = true
        else:
            sprite.flip_h = false
    
    if is_on_floor():
        if input.x == 0:
            linear_velocity.x = lerp(linear_velocity.x, 0, friction)
        if input.start_jump:
            linear_velocity.y = -jump_force
    else:
        if input.stop_jump && linear_velocity.y < -jump_force / 2:
            linear_velocity.y = -jump_force / 2
        if input.x == 0:
            linear_velocity.x = lerp(linear_velocity.x, 0, air_resistance)
    
    linear_velocity = move_and_slide(linear_velocity, Vector2.UP)

func to_dictionary():
    return {"x": position.x, "y": position.y, "flip": sprite.flip_h}

func from_dictionary(dictionary):
    if "x" in dictionary:
        position.x = dictionary["x"]
    if "y" in dictionary:
        position.y = dictionary["y"]
    if "flip" in dictionary:
        sprite.flip_h = dictionary["flip"]
