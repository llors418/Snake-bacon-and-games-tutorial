class_name StartScreen	extends CanvasLayer

const game_scene:PackedScene = preload("res://Scenes/game.tscn")

@onready var score = %ScoreLabel
@onready var start = %Startbutton
@onready var quit = %Quitbutton

# Called when the node enters the scene tree for the first time.
func _ready():
	var high_score:int = Global.save_data.high_score
	score.text = "High Score: " + str(high_score)
	pass # Replace with function body.



func _on_startbutton_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_quitbutton_pressed():
	get_tree().quit()
