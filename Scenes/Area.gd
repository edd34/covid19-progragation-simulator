extends Node2D

var rng = RandomNumberGenerator.new()

var nb_person = 100
const person = preload("res://Scenes/Person.tscn")
const person_script = preload("res://Scenes/Person.gd")
var list_instance = []

func _ready():
	for i in nb_person:
		var person_instance = person.instance()
		person_instance.set_script(person_script)
		set_age(person_instance)
		set_incubation_time(person_instance)
		set_recovering_time(person_instance)
		set_number_of_week_contagious_after_recovering(person_instance)
		set_probabilty_death_after_recovering(person_instance)
		person_instance.infected = false
		get_node(".").add_child(person_instance)
		list_instance.append(person_instance)
	get_node("Timer").connect("timeout", self, "_on_timeout")
		

func _input(event):
# Mouse in viewport coordinates
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			var random_instance = list_instance[rng.randi()% len(list_instance)]
			random_instance.state = random_instance.stage.I
			random_instance.date_since_infection = random_instance.incubation_time
		elif event.button_index == 2:
			for elem in list_instance:
				elem.state = elem.stage.S
				elem.date_since_infection = 0
				elem.collision_shape.disabled = false
		elif event.button_index == 3:
			var nb_S = 0
			var nb_E = 0
			var nb_I = 0
			var nb_R = 0
			var nb_D = 0
			print("Population NB = ", len(list_instance))
			for elem in list_instance:
				match elem.state:
					elem.stage.S:
						nb_S +=1
					elem.stage.E:
						nb_E +=1
					elem.stage.I:
						nb_I +=1
					elem.stage.R:
						nb_R +=1
					elem.stage.D:
						nb_D +=1
			print("Pourcentage S = ", nb_S * 100 / len(list_instance), " %")
			print("Pourcentage E = ", nb_E * 100 / len(list_instance), " %")
			print("Pourcentage I = ", nb_I * 100 / len(list_instance), " %")
			print("Pourcentage R = ", nb_R * 100 / len(list_instance), " %")
			print("Pourcentage D = ", nb_D * 100 / len(list_instance), " %")

	if event is InputEventKey and event.scancode == KEY_K and not event.echo:
		get_node("Container/Popup").show()

	if event is InputEventKey and event.scancode == KEY_L and not event.echo:
		get_node("Container/Popup").hide()
		pass
	
	if event is InputEventKey and event.scancode == KEY_SPACE and not event.echo:
		var person_instance = person.instance()
		person_instance.set_script(person_script)
		set_age(person_instance)
		set_incubation_time(person_instance)
		set_recovering_time(person_instance)
		set_number_of_week_contagious_after_recovering(person_instance)
		set_probabilty_death_after_recovering(person_instance)
		person_instance.infected = false
		get_node(".").add_child(person_instance)
		list_instance.append(person_instance)
	
#		print("Mouse Click/Unclick at: ", event.position)
#		get_node(".").add_child(person_instance)
#   if event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)
#   # Print the size of the viewport
#   print("Viewport Resolution is: ", get_viewport_rect().size)

func set_age(actor):
	var dice:float = 0.0
	rng.randomize()

	dice = rng.randf()
	if dice < 0.178:
		actor.age = rng.randi_range(0, 14)
	elif dice < 0.24:
		actor.age = rng.randi_range(15, 19)
	elif dice < 0.296:
		actor.age = rng.randi_range(20, 24)
	elif dice < 0.351:
		actor.age = rng.randi_range(25, 29)
	elif dice < 0.411:
		actor.age = rng.randi_range(30, 34)
	elif dice < 0.474:
		actor.age = rng.randi_range(35, 49)
	elif dice < 0.535:
		actor.age = rng.randi_range(40, 44)
	elif dice < 0.602:
		actor.age = rng.randi_range(45, 49)
	elif dice < 0.688:
		actor.age = rng.randi_range(50, 54)
	elif dice < 0.733:
		actor.age = rng.randi_range(55, 59)
	elif dice < 0.794:
		actor.age = rng.randi_range(60, 64)
	elif dice < 0.852:
		actor.age = rng.randi_range(65, 69)
	elif dice < 0.904:
		actor.age = rng.randi_range(70, 74)
	elif dice <=1 :
		actor.age = rng.randi_range(75, 95)

func set_incubation_time(actor):
	rng.randomize()
	if rng.randi() % 5 == 1:
		rng.randomize()
		actor.incubation_time = rng.randi_range(1,14)
	else:
		rng.randomize()
		actor.incubation_time = rng.randi_range(1,10)

func set_recovering_time(actor):
	rng.randomize()
	if rng.randi() % 5 == 1:
		rng.randomize()
		actor.recovering_time = rng.randi_range(5,14)
	else:
		rng.randomize()
		actor.recovering_time = rng.randi_range(5,10)
	pass

func set_probabilty_death_after_recovering(actor):
	rng.randomize()
	if actor.age < 15:
		actor.probability_death_after_recovering = 0
	elif actor.age >= 15 and actor.age < 44:
		actor.probability_death_after_recovering = 0.01
	elif actor.age >= 44  and actor.age < 64:
		actor.probability_death_after_recovering = 0.10
	elif actor.age >= 64 and actor.age < 74:
		actor.probability_death_after_recovering = 0.18
	elif actor.age >= 74:
		actor.probability_death_after_recovering = 0.71

func set_number_of_week_contagious_after_recovering(actor):
	rng.randomize()
	actor.number_of_week_contagious_after_recovering = rng.randi_range(14,30)

func _on_timeout():
	var res = ""
	for person in list_instance:
		res += str(person) + ' ' + str(person.age) + ' ' + \
			 str(person.incubation_time) + ' ' + str(person.recovering_time) + ' ' + \
			str(person.number_of_week_contagious_after_recovering) + ' '+\
			str(person.date_since_infection) + '\n'
	get_node("Container/Popup/RichTextLabel").text = res
	get_node("Container/Popup/RichTextLabel").rect_size.y = get_viewport().get_visible_rect().size.y
