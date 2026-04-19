extends CharacterBody2D


@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	
	var mouse_pos = get_global_mouse_position()
	
	
	var distance = global_position.distance_to(mouse_pos)
	
	
	if distance > 5.0:
		
		var direction = global_position.direction_to(mouse_pos)
		velocity = direction * speed
		
		
		move_and_slide()
	else:
		
		velocity = Vector2.ZERO
