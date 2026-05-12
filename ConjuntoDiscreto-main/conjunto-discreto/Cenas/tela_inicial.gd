extends Control
 
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/introducao.tscn")
 
func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/tutorial.tscn")
 
func _on_quit_pressed() -> void:
	get_tree().quit()
 
