extends TileMapLayer

var MAP_TILE_WIDTH = 50
var MAP_TILE_HEIGHT = 25
var TILE_SIZE = 16


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var schema = generate_schema()
	var basic_map = generate_basic_map(schema)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_schema():
	# create empty schema
	var schema = []
	for r in range(MAP_TILE_HEIGHT):
		var row = []
		for tile in range(MAP_TILE_WIDTH):
			row.append(-1)
		schema.append(row)
	return schema

func generate_basic_map(schema):
	var map = schema
	
	# add borders by default
	for y in range(len(map)):
		for x in range(y):
			if x == 0 \
			or x == MAP_TILE_WIDTH-1 \
			or y == 0 \
			or y == MAP_TILE_HEIGHT-1:
				map[y][x] = 1
				set_cell(Vector2i(x, y), 1, Vector2i(0,0))
	
	# add inner tiles
	var tiles_to_fill = (MAP_TILE_HEIGHT-2) * (MAP_TILE_WIDTH-2)
	while tiles_to_fill > 0:
		var x = randi_range(1, MAP_TILE_WIDTH-2)
		var y = randi_range(1, MAP_TILE_HEIGHT-2)
		if map[y][x] == -1:
			if y == MAP_TILE_HEIGHT-1 \
			or y == 0 \
			or x == MAP_TILE_WIDTH-1 \
			or x == 0:
				map[y][x] = 1
				set_cell(Vector2i(x, y), 1, Vector2i(0,0))
			else:
				var platform_heat = calculate_platform_heat(x,y, map)
				if platform_heat > randf():
					map[y][x] = 1
					set_cell(Vector2i(x, y), 1, Vector2i(0,0))
				else:
					map[y][x] = 0
					set_cell(Vector2i(x, y), 1, Vector2i(1,0))
			tiles_to_fill -= 1
	return map

func calculate_platform_heat(x, y, map):
	var platform_heat = 0.5
	
	# no possible platform if other platforms 
	# immediately above or below or in awkward positions
	if map[y-1][x] == 1 \
	or map[y+1][x] == 1 \
	or y > 1 and map[y-2][x] == 1 \
	or y < MAP_TILE_HEIGHT - 2 and map[y+2][x] == 1 \
	or map[y-1][x-1] == 1 and map[y-1][x+1] == 1 \
	or map[y+1][x-1] == 1 and map[y+1][x+1] == 1 \
	or x > 1 and map[y][x-2] == 1 and map[y+1][x-1] == 1 \
	or x > 1 and map[y][x-2] == 1 and map[y-1][x-1] == 1 \
	or x < MAP_TILE_WIDTH - 2 and map[y][x+2] == 1 and map[y+1][x+1] == 1 \
	or x < MAP_TILE_WIDTH - 2 and map[y][x+2] == 1 and map[y-1][x+1] == 1 :
		platform_heat = 0.0
		return platform_heat
	
	# reduce chance for awkward shapes
	if y > 1 and map[y-2][x-1] == 1:
		platform_heat -= 0.2
	if y > 1 and map[y-2][x+1] == 1:
		platform_heat -= 0.2
	if y < MAP_TILE_HEIGHT - 2 and map[y+2][x-1] == 1:
		platform_heat -= 0.2
	if y < MAP_TILE_HEIGHT - 2 and map[y+2][x+1] == 1:
		platform_heat -= 0.2
	
	# check parallels (for building "platforms")
	if map[y][x-1] == 1:
		platform_heat += 0.4
	if map[y][x+1] == 1:
		platform_heat += 0.4
	if x > 1 and map[y][x-2] == 1:
		platform_heat += 0.2
	if x < MAP_TILE_WIDTH -2 and map[y][x+2] == 1:
		platform_heat += 0.2
	
	return platform_heat
