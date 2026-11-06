
extends CharacterBody2D

@export var velocidad: float = 450.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animacion: AnimationPlayer = $AnimationPlayer


func _physics_process(_delta: float) -> void:
	# Movimiento con las flechas
	var direccion = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)

	# Movimiento libre sin gravedad
	velocity = direccion * velocidad

	# Animaciones del personaje
	if direccion != Vector2.ZERO:
		if animacion.current_animation != "run":
			animacion.play("run")

		# Girar personaje horizontalmente
		if direccion.x < 0:
			sprite.flip_h = true
		elif direccion.x > 0:
			sprite.flip_h = false

	else:
		if animacion.current_animation != "idle":
			animacion.play("idle")

	# Aplicar movimiento y colisiones
	move_and_slide()



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/niveles.tscn")
