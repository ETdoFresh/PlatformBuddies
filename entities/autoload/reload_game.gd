extends Node

const MAIN_MENU = preload("res://entities/menu/menu.tscn")

func _input(event):
    if event is InputEventKey:
        if event.is_pressed():
            if Input.is_key_pressed(KEY_CONTROL):
                if event.scancode == KEY_R:
                    var _1 = get_tree().change_scene_to(MAIN_MENU)
