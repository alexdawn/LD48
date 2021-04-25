extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start_pos
export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
    start_pos = $Lift.position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if Input.is_action_pressed("lift_down"):
        $LiftWheel.rotate(PI / 180 * speed * delta)
        $Lift.move_and_slide(Vector2(0, 4 * speed / 2), Vector2.UP,
                    false, 4, PI/4, false) # needed to stop pressing player into ground
        for index in $Lift.get_slide_count():
            var collision = $Lift.get_slide_collision(index)
            if collision.collider.is_in_group("bodies"):
                collision.collider.apply_central_impulse(-collision.normal * 20)
    if Input.is_action_pressed("lift_up"):
        if $Lift.position.y > start_pos:
            $LiftWheel.rotate(-PI / 180 * speed * delta)
            $Lift.move_and_collide(Vector2((start_pos - $Lift.position.x) * 0.1 * speed * delta, -2 * speed * delta))
