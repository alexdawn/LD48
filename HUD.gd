extends CanvasLayer

signal sfx
var score = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $Menu/ResumeButton.visible = Globals.resume_visibility
    $Menu/StartButton.text = Globals.start_text
    $Menu.visible = Globals.menu_state
    $Menu/Music.value = Globals.music
    $Menu/Audio.value = Globals.audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("ui_cancel"):
        $Menu.visible = true


func _on_Player_pos(pos):
    $Depth.text = 'Depth: %dm' % (pos.y / 64)


func _on_Map_collect_gold():
    score += 1
    $Score.text = 'Score: %d Gold' % score


func _on_StartButton_pressed():
    Globals.fix_menu()
    Globals.music = $Menu/Music.value
    Globals.audio = $Menu/Audio.value
    get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed():
    get_tree().quit()


func _on_ResumeButton_pressed():
    $Menu.visible = false


func _on_Music_value_changed(value):
    $AudioStreamPlayer.set_volume_db((value-100)*0.6)


func _on_Audio_value_changed(value):
    emit_signal("sfx", value)


func _on_CreditsButton_pressed():
    pass # Replace with function body.


func _on_CreditsButton_button_down():
    $Menu/Sprite.visible = !$Menu/Sprite.visible
    $Menu/Label.visible = !$Menu/Label.visible
