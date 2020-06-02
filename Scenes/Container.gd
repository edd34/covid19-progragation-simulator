extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var AreaNode = get_node('../Area')

# Called when the node enters the scene tree for the first time.
func _ready():
	print(AreaNode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
