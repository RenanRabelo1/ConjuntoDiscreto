extends Node

@export var npc_scene: PackedScene

# Arraste o nó LimiteDoMapa para cá no Inspetor
@onready var limite_do_mapa = $"../LimiteDoMapa"

func _ready() -> void:
	spawn_npcs(5)

func spawn_npcs(quantidade: int) -> void:
	if not npc_scene:
		print("ERRO: npc_scene não foi atribuída no Inspetor do GameManager!")
		return

	# Pega os limites reais do mapa (não da tela)
	var rect: Rect2
	if limite_do_mapa and limite_do_mapa is CollisionShape2D:
		var shape = limite_do_mapa.shape
		if shape is RectangleShape2D:
			var centro = limite_do_mapa.global_position
			var metade = shape.size / 2.0
			rect = Rect2(centro - metade, shape.size)
	else:
		# Fallback: usa a tela inteira se não achar o limite
		rect = Rect2(Vector2(50, 50), get_viewport().get_visible_rect().size - Vector2(100, 150))

	for i in range(quantidade):
		var npc = npc_scene.instantiate()

		# Spawna como filho do mapa (não do GameManager)
		get_parent().add_child(npc)

		# Posição aleatória dentro dos limites do mapa
		var x = randf_range(rect.position.x + 60, rect.end.x - 60)
		var y = randf_range(rect.position.y + 60, rect.end.y - 60)
		npc.global_position = Vector2(x, y)

# Chame essa função para reiniciar os conjuntos (ex: após completar missão)
func respawnar_npcs() -> void:
	# Remove os NPCs antigos
	for filho in get_parent().get_children():
		if filho.name.begins_with("outro_conjunto"):
			filho.queue_free()
	# Aguarda um frame para o free acontecer
	await get_tree().process_frame
	spawn_npcs(5)
