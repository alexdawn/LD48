extends Node

var menu_state = true
var resume_visibility = false
var start_text = "Start"
var music = 75
var audio = 75
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func fix_menu():
    menu_state = false
    resume_visibility = true
    start_text = "Restart"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
