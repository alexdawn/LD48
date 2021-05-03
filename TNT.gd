extends RigidBody2D
signal explode(tnt)
# need to have a fuse countdown, then explode
# make signal to destroy map

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = Timer.new()
var timer_flash = Timer.new()
var is_exploding = false

# Called when the node enters the scene tree for the first time.
func _ready():
    connect("explode",  get_tree().current_scene, "_on_explode")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    $FuseParticles.set_position(Vector2(0, -32 * $Fuse.time_left / $Fuse.get_wait_time()))

func end_flash():
    $ExplosionFlash.energy = 0
    

func explode():
    if not is_exploding:
        is_exploding = true
        emit_signal("explode", self)
        $ExplosionFlash.energy = 10
        $ExplosionParticles.emitting = true
        $FuseParticles.emitting = false
        $TNTShape.queue_free()
        $TNTCollisionBox.queue_free()
        $AnimatedSprite.visible = true
        $AnimatedSprite.play()
        self.add_child(timer)
        self.add_child(timer_flash)
        timer.connect("timeout", self, "queue_free")
        timer_flash.connect("timeout", self, "end_flash")
        timer_flash.set_wait_time(0.1)
        timer_flash.start()
        timer.set_wait_time(5)
        timer.start()
    

func _on_Fuse_timeout():
    explode()
