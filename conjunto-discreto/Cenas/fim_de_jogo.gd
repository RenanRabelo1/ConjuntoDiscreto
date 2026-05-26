extends Node2D


func _on_jogar_novamente_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/tela_inicial.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()
