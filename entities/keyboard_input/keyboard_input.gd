extends Node

var x = 0
var jump = false
var was_jump = false
var start_jump = false
var stop_jump = false

func simulate(_delta):
    x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    jump = Input.is_action_pressed("ui_up")    
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

func to_dictionary():
    return {"x": x, "jump": jump}
