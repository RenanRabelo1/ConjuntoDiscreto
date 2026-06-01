extends Node2D

func _ready() -> void:
	# --- EXIBIR O TEMPO DE JOGO ---
	if has_node("LabelTempoFinal"):
		# Agora ele busca direto da memória Global estável!
		$LabelTempoFinal.text = "Tempo Total: " + Global.tempo_final
	else:
		print("⚠️ Erro: Não encontrei o nó LabelTempoFinal na cena!")

func _on_jogar_novamente_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/tela_inicial.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()
