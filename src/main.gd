extends Area2D

var tiles = []
var solved = []
var mouse = false
var tile = preload("res://tile.tscn")
var tile_h
var offset
var t
var movecounter = 0
var previous = ""

func _ready():
	start_game()
	

func start_game():
	tile_h = get_window().get_size().x / 4
	var image = Image.load_from_file("res://img/pink_DeLorian.png")
	var texture = ImageTexture.create_from_image(image)
	var greyimage = Image.load_from_file("res://img/greytile.png")
	var greytexture = ImageTexture.create_from_image(greyimage)
	$FullImage.texture = texture

	
	for j in range(0,4):
		for i in range(0,4):
			var myregion = Rect2i(i * tile_h,j * tile_h,tile_h,tile_h)
			var newimage = image.get_region(myregion)
			var newtexture = ImageTexture.create_from_image(newimage)
			var newtile = tile.instantiate()
			newtile.position.x = tile_h * i + tile_h/2 + i*2
			newtile.position.y = tile_h * j + tile_h/2 + j*2
			newtile.tilename = "Tile" + str(j * 4 + i + 1)
			if newtile.tilename == "Tile16":
				newtile.tiletexture = greytexture
				newtile.realtexture = newtexture
			else:
				newtile.tiletexture = newtexture
			add_child(newtile)
			tiles.append(newtile)

	solved = tiles.duplicate()
	shuffle_tiles()
	movecounter = 0

func shuffle_tiles():
	offset = tile_h + 2
	t = 0
	while t < 3:
		var atile = randi() % 16
		if tiles[atile].tilename != "Tile16" and tiles[atile].tilename != previous:
			var rows = int(tiles[atile].position.y / offset)
			var cols = int(tiles[atile].position.x / offset)
			check_neighbours(rows,cols)



func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y / offset)
		var cols = int(mouse_copy.position.x / offset)
		check_neighbours(rows,cols)
		if tiles == solved and movecounter > 1:
			print("You win in ", str(movecounter, " moves!!"))
			$FullImage.show()
			

func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols
	while !empty and !done:
		var new_pos = tiles[pos].position
		if rows < 3:
			new_pos.y += offset
			empty = find_empty(new_pos,pos)
			new_pos.y -= offset
		if rows > 0:
			new_pos.y -= offset
			empty = find_empty(new_pos,pos)
			new_pos.y += offset
		if cols < 3:
			new_pos.x += offset
			empty = find_empty(new_pos,pos)
			new_pos.x -= offset
		if cols > 0:
			new_pos.x -= offset
			empty = find_empty(new_pos,pos)
			new_pos.x += offset
		done = true

func find_empty(position,pos):
	var new_rows = int(position.y / offset)
	var new_cols = int(position.x / offset)
	var new_pos = new_rows * 4 + new_cols
	if tiles[new_pos].tilename == "Tile16" and tiles[new_pos].tilename != previous:
		swap_tiles(pos, new_pos)
		t += 1
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
	movecounter += 1
	previous = tiles[tile_dst].tilename


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event



