extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var nb_person = 3
const person = preload("res://Scenes/Person.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in nb_person:
		var PERSON = person.instance()
		PERSON.position = Vector2(0,0)
		get_parent().add_child(PERSON)

func _process(delta):
	pass
