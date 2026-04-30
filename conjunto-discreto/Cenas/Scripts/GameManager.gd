extends Node

@export var npc_scene: PackedScene # Certifica-te de que arrastaste o outro_conjunto.tscn para aqui no Inspetor

func _ready() -> void:
	# Vamos começar com 5 NPCs para testar
	spawn_npcs(5)

func spawn_npcs(quantidade: int):
	# Captura o tamanho real da área de jogo para não usar números fixos
	var screen_size = get_viewport().get_visible_rect().size
	
	for i in range(quantidade):
		if npc_scene:
			var npc = npc_scene.instantiate()
			
			# Define a posição aleatória dentro dos limites do ecrã
			var x = randf_range(50, screen_size.x - 50)
			var y = randf_range(50, screen_size.y - 50)
			npc.position = Vector2(x, y)
			
			add_child(npc)
		else:
			print("ERRO: npc_scene não foi atribuída no Inspetor do GameManager!")
