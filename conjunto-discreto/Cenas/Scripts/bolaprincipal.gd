extends CharacterBody2D

# --- VARIÁVEIS E NÓS ---
@export var speed: float = 300.0
const UNIVERSO = ["estrela", "quadrado", "coracao"]

var meu_conjunto: Array = [] # Começa vazio!
var poder_ativo: String = "uniao"

@onready var sprite_estrela = $Formas/Estrela
@onready var sprite_quadrado = $Formas/Quadrado
@onready var sprite_coracao = $Formas/Coracao


func _ready() -> void:
	atualizar_visual()

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var distance = global_position.distance_to(mouse_pos)
	
	if distance > 5.0:
		var direction = global_position.direction_to(mouse_pos)
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func interacao(outro_conjunto: Array) -> void:
	if poder_ativo == "uniao":
		for forma in outro_conjunto:
			if not meu_conjunto.has(forma):
				meu_conjunto.append(forma)
				print("Absorvi a forma: ", forma)
				
	elif poder_ativo == "interseccao":
		var lista = []
		for forma in meu_conjunto:
			if outro_conjunto.has(forma):
				lista.append(forma)
		meu_conjunto = lista
		print("Fiz intersecção! Agora tenho só ", meu_conjunto)
		
	print("Meu conjunto atual: ", meu_conjunto)
	
	atualizar_visual()

# --- NOVO VISUAL COM SHOW/HIDE ---
func atualizar_visual() -> void:
	if meu_conjunto.has("estrela"):
		sprite_estrela.show()
	else:
		sprite_estrela.hide()
		
	if meu_conjunto.has("quadrado"):
		sprite_quadrado.show()
	else:
		sprite_quadrado.hide()
		
	if meu_conjunto.has("coracao"):
		sprite_coracao.show()
	else:
		sprite_coracao.hide()
