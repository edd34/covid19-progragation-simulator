extends Node2D

var rng = RandomNumberGenerator.new()
enum direction {NE = 0, NO = 1, SE = 2, SO = 3}

func convert_direction_vector2(index):
	if index == direction.NE:
		return Vector2(-1, 1)
	elif index == direction.NO:
		return Vector2(-1, -1)
	elif index == direction.SE:
		return Vector2(1, 1)
	elif index == direction.SO:
		return Vector2(1, -1)

var size_viewport
var randomized_direction_index:int
var current_direction:Vector2 = Vector2(0,0)
onready var size_sprite = get_node("./Sprite").texture.get_size()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomized_direction_index = direction.values()[ rng.randi()%direction.size()]
	size_viewport = get_viewport().get_visible_rect().size
	position = Vector2(rng.randi() % int(size_viewport.x), rng.randi() % int(size_viewport.y))
	current_direction = convert_direction_vector2(randomized_direction_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(position, current_direction)
	size_viewport = get_viewport().get_visible_rect().size
	if position.y + size_sprite.y/2 >= size_viewport.y:
		current_direction.y = -1
	if position.y - size_sprite.y/2 <= 0:
		current_direction.y = 1
	if position.x + size_sprite.x/2 >= size_viewport.x:
		current_direction.x = -1
	if position.x  - size_sprite.x/2 <= 0:
		current_direction.x = 1

	position += current_direction
