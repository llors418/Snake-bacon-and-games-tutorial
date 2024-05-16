class_name GameOver extends CanvasLayer

@onready var score = %ScoreLabel
@onready var high_score = %HighScoreLabel
@onready var restart = %RestartButton
@onready var quit = %QuitButton

func set_score(n:int):
	score.text = "Final Score" + str(n)
	if n > Global.save_data.high_score:
		high_score.visible = true
		Global.save_data.high_score = n
		Global.save_data.save()
	else:
		high_score.visible = false

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
			
