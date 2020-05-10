extends KinematicBody2D

var rng = RandomNumberGenerator.new()
enum direction {NE = 0, NO = 1, SE = 2, SO = 3}
enum stage {S = 0, E = 1, I = 2, R = 3, D = 4}

var infected: bool = false
var speed = 100
var age = -1
var incubation_time = 0
var recovering_time = 0
var probability_death_after_recovering = 0
var number_of_week_contagious_after_recovering = 0
var contagious = false
var date_since_infection = 0
var state = stage.S

onready var sprite_node = get_node("./CollisionShape2D/Sprite")
onready var timer_node = get_node("Timer")
onready var collision_shape = get_node("./CollisionShape2D")

var size_viewport
var randomized_direction_index:int
var current_direction:Vector2 = Vector2(0,0)
onready var size_sprite = sprite_node.texture.get_size()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomized_direction_index = direction.values()[ rng.randi()%direction.size()]
	size_viewport = get_viewport().get_visible_rect().size
	position = Vector2(rng.randi() % int(size_viewport.x), rng.randi() % int(size_viewport.y))
	current_direction = convert_direction_vector2(randomized_direction_index)
	timer_node.connect("timeout", self, "_on_timeout")

func _process(delta):
#	print(position, current_direction)
	rng.randomize()
	size_viewport = get_viewport().get_visible_rect().size
	if position.y + size_sprite.y/2 >= size_viewport.y:
		current_direction.y = -1*rng.randf_range(0,1)
	if position.y - size_sprite.y/2 <= 0:
		current_direction.y = 1*rng.randf_range(0,1)
	if position.x + size_sprite.x/2 >= size_viewport.x:
		current_direction.x = -1*rng.randf_range(0,1)
	if position.x  - size_sprite.x/2 <= 0:
		current_direction.x = 1*rng.randf_range(0,1)

	var collision_info = move_and_collide(Vector2(current_direction.x, current_direction.y) * delta * speed)
	if collision_info:
		current_direction = Vector2(current_direction.x, current_direction.y).bounce(collision_info.normal)
		if state == stage.S and collision_info.collider.state == stage.I:
				state = stage.E
				timer_node.autostart = true
				timer_node.start()
		if state == stage.I :
			pass
		if collision_info.collider.state == stage.R and \
		 	collision_info.collider.date_since_infection <= collision_info.collider.incubation_time+collision_info.collider.recovering_time+collision_info.collider.number_of_week_contagious_after_recovering:
			state = stage.E
			timer_node.autostart = true
			timer_node.start()
		if state == stage.D :
			collision_shape.set_disabled(true)

		if state == stage.E and date_since_infection > incubation_time:
			state = stage.I
		if date_since_infection > (incubation_time+recovering_time) and state == stage.I:
			rng.randomize()
			if rng.randf() < probability_death_after_recovering:
				state = stage.D
			else:
				state = stage.R

	update_color()

func convert_direction_vector2(index):
	if index == direction.NE:
		return Vector2(-1, 1)
	elif index == direction.NO:
		return Vector2(-1, -1)
	elif index == direction.SE:
		return Vector2(1, 1)
	elif index == direction.SO:
		return Vector2(1, -1)

func probability_death_by_age():
	if age < 15:
		return 0
	elif age >= 15 and age <= 44:
		return 0.01
	elif age > 44 and age <= 64:
		return 0.1
	elif age >= 65 and age <= 75:
		return 0.18
	elif age >= 75:
		return 0.71

func _on_timeout():
	date_since_infection = date_since_infection + 1

func update_color():
	if state == stage.S:
		sprite_node.modulate = Color.yellow
	elif state == stage.E:
		sprite_node.modulate = Color.orange
	elif state == stage.I:
		sprite_node.modulate = Color.red
	elif state == stage.R:
		sprite_node.modulate = Color.green
	elif state == stage.D:
		sprite_node.modulate = Color.black
	pass
