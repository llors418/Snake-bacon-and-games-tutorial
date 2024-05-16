class_name Game extends Node2D

const gameover_scene:PackedScene = preload("res://Scenes/game_over.tscn")
const pausemenu_scene:PackedScene = preload("res://Scenes/pause_menu.tscn")

@onready var head = %Head as Head
@onready var bound = $Bounds 
@onready var spawner = $Spawner as Spawner
@onready var hud = $HUD as HUD

var gameover_menu:GameOver
var pause_menu:PauseMenu
var time_between_moves:float = 1000.0
var time_since_last_move:float = 0
var speed:float = 5000.0
var move_dir:Vector2 = Vector2.RIGHT # Vector2(1,0)
var snake_parts:Array[SnakePart] = []
var score:int:
	get:
		return score
	set(value):
		score = value
		hud.update_score(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	head.coin_pick.connect(_on_coin_pick)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	
	time_since_last_move = time_between_moves
	spawner.Spawn_food()
	snake_parts.push_back(head)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	var new_dir:Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("SnakeUP"):
		new_dir = Vector2.UP # (0,	-1)
	elif Input.is_action_pressed("SnakeRight"):
		new_dir = Vector2.RIGHT # (1,0)
	elif Input.is_action_pressed("SnakeDown"):
		new_dir = Vector2.DOWN # (0, 1)
	elif Input.is_action_pressed("SnakeLeft"):
		new_dir = Vector2.LEFT # (-1,0)
		
	# dont allow the player to reverse directions
	if new_dir + move_dir != Vector2.ZERO and new_dir != Vector2.ZERO:
		move_dir = new_dir
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()
	
func _physics_process(delta):
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0

func update_snake():
	#move_dir, by how much
	var new_pos:Vector2 = head.position + move_dir * Global.GRID_SIZE
	new_pos = bound.wrap_vector(new_pos)
	head.move_to(new_pos)
	
	for i in range(1, snake_parts.size(),1):
		snake_parts[i].move_to(snake_parts[i-1].last_position)
	pass
	
func _on_coin_pick():
	#spawn more coins
	spawner.call_deferred("Spawn_food")
	spawner.call_deferred("spawn_tail",snake_parts[snake_parts.size()-1].last_position)
	speed += 250.0
	score += 1
	
func _on_tail_added(tail:Tail):
	snake_parts.push_back(tail)
	
func _on_tail_collided():
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		gameover_menu.set_score(score)
		
func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()

func pause_game():
	if not pause_menu:
		pause_menu = pausemenu_scene.instantiate() as PauseMenu
		add_child(pause_menu)
