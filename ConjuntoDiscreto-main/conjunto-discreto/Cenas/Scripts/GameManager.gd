extends Node

@export var npc_scene: PackedScene

func _ready() -> void:
	# Espera um frame para o mapa carregar completamente
	await get_tree().process_frame
	spawn_npcs(5)

func spawn_npcs(quantidade: int) -> void:
	if not npc_scene:
		print("ERRO: arraste o outro_conjunto.tscn para o campo npc_scene no Inspector!")
		return

	var screen_size = get_viewport().get_visible_rect().size

	for i in range(quantidade):
		var npc = npc_scene.instantiate()
		get_parent().add_child(npc)

		# Posição aleatória evitando bordas e a UI de baixo
		var x = randf_range(100, screen_size.x - 100)
		var y = randf_range(100, screen_size.y - 200)
		npc.global_position = Vector2(x, y)
		print("Spawnado outro_conjunto em: ", npc.global_position)

func respawnar_npcs() -> void:
	# Remove todos os outro_conjunto existentes
	for filho in get_parent().get_children():
		if filho.name.begins_with("outro_conjunto"):
			filho.queue_free()
	await get_tree().process_frame
	spawn_npcs(5)
