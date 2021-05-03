extends Node

signal collect_gold

var noise = OpenSimplexNoise.new()
var generated_blocks = {"0 0": true}
var current_block = Vector2(0, 0)


func handle_explode(tnt):
    destroy_tiles(tnt.get_global_position(), 3)


func generate_block(x0, y0):
    for x in range(16):
        for y in range(16):
            var sample = noise.get_noise_2d(x0*16+x, y0*16+y)
            var index
            if sample > 0.3:
                index = 1
            elif sample > -0.2:
                if y0*16+y == 0:
                    index = 3
                    $TileMap.set_cell(x0*16+x, y0*16+y-1, 4) # grass tile
                else:
                    index = 0
            else:
                index = 2
            $TileMap.set_cell(x0*16+x, y0*16+y, index)


func _ready():
    $TileMap.clear()
    noise.seed = randi()
    noise.octaves = 4
    noise.period = 20.0
    noise.persistence = 0.8
    generate_block(0, 0)
    # dig out lift shaft
    for i in range (1, 3):
        for j in range(16):
            $TileMap.set_cell(i, j, 2)
    
    
func generate_nearby_blocks(pos):
    var map_position = $TileMap.world_to_map(pos)
    var block = Vector2(floor(map_position.x /  16), floor(map_position.y / 16))
    if current_block != block:
        #print(block)
        for i in range(-1, 2):
            for j in range(-1, 2):
                if block.y + j >= 0 and not generated_blocks.get("%s %s" % [block.x + i, block.y + j]):
                    generate_block(block.x + i, block.y + j)
                    generated_blocks["%s %s" % [block.x + i, block.y + j]] = true
        current_block = block

func destroy_tiles(pos, radius):
    var map_position = $TileMap.world_to_map(pos)
    var rad_square = pow(radius, 2)
    for i in range(-radius, radius+1):
        for j in range(-radius, radius+1):
            #print(i, j)
            if pow(i, 2) + pow(j, 2) <= rad_square:
                #print("destroy")
                if $TileMap.get_cell(map_position.x+i, map_position.y+j) in [0, 1, 3]:
                    destroy_tiles_map_coord(
                        Vector2(map_position.x+i, map_position.y+j),
                        2
                    )
                
    
    
func destroy_tile(pos, target):
    var map_position = $TileMap.world_to_map(pos)
    destroy_tiles_map_coord(map_position, target)
    

func destroy_tiles_map_coord(map_position, target):
    if $TileMap.get_cell(map_position.x, map_position.y) == 1:
        $GoldSound.play()
        emit_signal("collect_gold")
    if $TileMap.get_cell(map_position.x, map_position.y) == 3:
        destroy_tiles_map_coord(Vector2(map_position.x, map_position.y-1), -1) # destroy grass tile on top
    $TileMap.set_cell(map_position.x, map_position.y, target)
    $TileMapCracks.set_cell(map_position.x, map_position.y, -1)


func _on_Player_hit(pos):
    var map_position = $TileMap.world_to_map(pos)
    $DigSound.play()
    if $TileMapCracks.get_cell(map_position.x, map_position.y) == 3:
        destroy_tile(pos, 2) # Replace with function body.
    elif $TileMap.get_cell(map_position.x, map_position.y) in [0, 1, 3]: 
         $TileMapCracks.set_cell(
            map_position.x, map_position.y, 
            $TileMapCracks.get_cell(map_position.x, map_position.y) + 1
        )


func _on_Player_pos(pos):
    generate_nearby_blocks(pos)


func _on_HUD_sfx(value):
    $DigSound.set_volume_db((value-100)*0.6)
    $GoldSound.set_volume_db((value-100)*0.6)
