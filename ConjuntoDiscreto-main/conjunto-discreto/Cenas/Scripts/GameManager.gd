extends Node

@export var npc_scene: PackedScene

# Distância mínima (em pixels) que uma bolinha deve ficar da outra
@export var distancia_minima: float = 120.0 

func _ready() -> void:
	# Espera um frame para o mapa carregar completamente
	await get_tree().process_frame
	spawn_npcs(10)

func spawn_npcs(quantidade: int) -> void:
	if not npc_scene:
		print("ERRO: arraste o outro_conjunto.tscn para o campo npc_scene no Inspector!")
		return

	var screen_size = get_viewport().get_visible_rect().size
	
	# Array para guardar as posições das bolinhas que já nasceram nesta rodada
	var posicoes_ocupadas: Array[Vector2] = []

	for i in range(quantidade):
		var posicao_valida = Vector2.ZERO
		var encontrou_posicao = false
		
		var tentativas = 0
		var max_tentativas = 100 # Evita que o jogo trave em loop infinito se o mapa estiver lotado
		
		# Fica tentando achar um lugar limpo até conseguir ou estourar o limite de tentativas
		while not encontrou_posicao and tentativas < max_tentativas:
			tentativas += 1
			
			# Posição aleatória temporária
			var x = randf_range(100, screen_size.x - 100)
			var y = randf_range(100, screen_size.y - 200)
			var posicao_candidata = Vector2(x, y)
			
			# Verifica se essa posição candidata está muito perto de alguma bolinha já criada
			var muito_perto = false
			for pos in posicoes_ocupadas:
				if posicao_candidata.distance_to(pos) < distancia_minima:
					muito_perto = true
					break # Já está perto de uma, nem precisa checar o resto
			
			# Se não ficou perto de ninguém, achamos o lugar perfeito!
			if not muito_perto:
				posicao_valida = posicao_candidata
				encontrou_posicao = true
		
		# Se o loop terminou e achamos uma posição, spawna o NPC ali
		if encontrou_posicao:
			var npc = npc_scene.instantiate()
			get_parent().add_child(npc)
			npc.global_position = posicao_valida
			
			# Guarda a posição dessa nova bolinha para que as próximas não batam nela
			posicoes_ocupadas.append(posicao_valida)
			print("Spawnado outro_conjunto sem sobreposição em: ", npc.global_position)
		else:
			print("⚠️ Aviso: Não havia espaço livre suficiente na tela para a bolinha nº ", i)

func respawnar_npcs() -> void:
	# Remove todos os outro_conjunto existentes
	for filho in get_parent().get_children():
		if filho.name.begins_with("outro_conjunto"):
			filho.queue_free()
	await get_tree().process_frame
	spawn_npcs(5)
