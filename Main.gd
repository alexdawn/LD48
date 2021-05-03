extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_explode(tnt):
    # make a hole in the map
    $Map.handle_explode(tnt)
    
    for tnt2 in get_tree().get_nodes_in_group("tnt"):
        var seperation = tnt2.get_global_position() - tnt.get_global_position()
        if seperation.length() < 128:
            tnt2.explode()
    
    # push player
    var seperation = $Player.get_global_position() - tnt.get_global_position()
    if seperation.length() < 128:
        print(1000 * seperation.normalized())
        $Player.apply_central_impulse(
            5e6 * seperation.normalized() * 1 / seperation.length()
        )
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
