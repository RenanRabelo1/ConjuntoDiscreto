extends Control
 
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/mapa_1.tscn")
 
func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/tutorial.tscn")
 
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/options.tscn")
 
func _on_quit_pressed() -> void:
	get_tree().quit()
 
