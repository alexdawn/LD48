extends RigidBody2D

signal hit
signal pos
signal throw
export var speed = 200
var last_motion = 'down'
var explosives = 3
var tnt = preload("res://TNT.tscn")

func _ready():
    pass

func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("action_1"):
        velocity.x = 1
        $MiningArea.position.x = 25
        last_motion = 'right'
    if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("action_1"):
        velocity.x = -1
        $MiningArea.position.x = -25
        last_motion = 'left'
    if Input.is_action_pressed("ui_down"):
        last_motion = 'down'
    if Input.is_action_pressed("action_2"):
        if len($JumpArea.get_overlapping_bodies()) > 1:
            velocity.y = -2
            $JumpSound.play()
    if velocity.length() > 0:
        velocity = velocity * speed
        $AnimatedSprite.play()
    else:
        if Input.is_action_pressed("action_1"):
            if last_motion == 'down':
                $AnimatedSprite.animation = "DigDown"
                $AnimatedSprite.speed_scale = 3
            else:
                $AnimatedSprite.animation = "Dig"
                $AnimatedSprite.speed_scale = 4
        else:
            $AnimatedSprite.animation = "Resting"
            $AnimatedSprite.speed_scale = 1
    if velocity.x != 0:
        $AnimatedSprite.animation = "Walk"
        $AnimatedSprite.speed_scale = 1
        $AnimatedSprite.flip_h = velocity.x < 0
    set_axis_velocity(velocity)
    if linear_velocity.x != 0 or linear_velocity.y != 0:
        emit_signal("pos", global_position)
    if Input.is_action_just_released("throw") and explosives > 0:
        var main = get_tree().current_scene
        var tnt_instance = tnt.instance()
        main.add_child(tnt_instance)
        tnt_instance.set_global_position($MiningArea.get_global_position())
        tnt_instance.set_axis_velocity(10 * $MiningArea.get_position())
        explosives -= 1
        emit_signal("throw", explosives)


func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "DigDown":
        emit_signal("hit", $MiningAreaDown.global_position)
    elif $AnimatedSprite.animation == "Dig":
        emit_signal("hit", $MiningArea.global_position)
    

func _on_HUD_sfx(value):
    $WalkSound.set_volume_db((value-100)*0.6-10)
    $JumpSound.set_volume_db((value-100)*0.6)
    $JumpSound.play()


func _on_AnimatedSprite_frame_changed():
    if $AnimatedSprite.animation == "Walk" and len($JumpArea.get_overlapping_bodies()) > 1 and !$WalkSound.playing:
        $WalkSound.play()
