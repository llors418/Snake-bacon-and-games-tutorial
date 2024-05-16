class_name Spawner extends Node2D

signal tail_added(tail:Tail)

# signals
# export variables

@export var Bounds:bounds
# instantiating packed scenes
var food_scene:PackedScene = preload("res://Scenes/coin.tscn")
var tail_scene:PackedScene = preload("res://Scenes/tail.tscn")


func Spawn_food():
	# where to spawn it (position)
	var Spawn_point:Vector2 = Vector2.ZERO
	Spawn_point.x = randf_range(Bounds.x_min + Global.GRID_SIZE, Bounds.x_max - Global.GRID_SIZE)
	Spawn_point.y = randf_range(Bounds.y_min + Global.GRID_SIZE, Bounds.y_max - Global.GRID_SIZE)
	
	Spawn_point.x = floorf(Spawn_point.x / Global.GRID_SIZE) * Global.GRID_SIZE
	Spawn_point.y = floorf(Spawn_point.y / Global.GRID_SIZE) * Global.GRID_SIZE
	
	# what we're spawning (instantiation)
	var food = food_scene.instantiate()
	food.position = Spawn_point
	# where we're spawning (parenting)
	get_parent().add_child(food)
	pass
	
func spawn_tail(pos:Vector2):
	var tail:Tail = tail_scene.instantiate() as Tail
	tail.position = pos
	get_parent().add_child(tail)
	tail_added.emit(tail)
	pass
	
