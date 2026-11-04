
extends CharacterBody2D

@export var velocidad: float = 450.0
@export var fuerza_salto: float = -800.0
@export var exploracion_libre: bool = false
@export var velocidad_exploracion: float = 300.0
@export var limites_verticales: Vector2 = Vector2(90.0, 200.0)
@export var impulso_salto_exploracion: float = 260.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animacion: AnimationPlayer = $AnimationPlayer

var gravedad: float = 980.0
var altura_salto: float = 0.0
var velocidad_salto: float = 0.0
var posicion_sprite: Vector2

func _ready() -> void:
	posicion_sprite = sprite.position
	if exploracion_libre:
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	if exploracion_libre:
		mover_exploracion(delta)
		return

	if not is_on_floor():
		velocity.y += gravedad * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = fuerza_salto

	var direccion := Input.get_axis("ui_left", "ui_right")
	velocity.x = direccion * velocidad

	if direccion != 0:
		sprite.flip_h = direccion < 0

	move_and_slide()
	actualizar_animacion()


func mover_exploracion(delta: float) -> void:
	var direccion := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var teclado := Vector2(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	)
	direccion = (direccion + teclado).limit_length(1.0)
	velocity = direccion * velocidad_exploracion

	if direccion.x != 0:
		sprite.flip_h = direccion.x < 0

	move_and_slide()
	global_position.y = clampf(global_position.y, limites_verticales.x, limites_verticales.y)

	# La altura del salto es independiente del suelo y de la camara.
	if Input.is_action_just_pressed("ui_accept") and altura_salto <= 0.0:
		velocidad_salto = impulso_salto_exploracion
	if altura_salto > 0.0 or velocidad_salto > 0.0:
		altura_salto = maxf(0.0, altura_salto + velocidad_salto * delta - 0.5 * gravedad * delta * delta)
		velocidad_salto -= gravedad * delta
		if altura_salto <= 0.0:
			velocidad_salto = 0.0
	sprite.position = posicion_sprite + Vector2(0.0, -altura_salto)

	if altura_salto > 0.0:
		reproducir_animacion("jump" if velocidad_salto > 0.0 else "fall")
	elif direccion != Vector2.ZERO:
		reproducir_animacion("run")
	else:
		reproducir_animacion("idle")


func actualizar_animacion() -> void:
	if not is_on_floor():
		if velocity.y < 0:
			reproducir_animacion("jump")
		else:
			reproducir_animacion("fall")
	elif abs(velocity.x) > 0:
		reproducir_animacion("run")
	else:
		reproducir_animacion("idle")


func reproducir_animacion(nombre: String) -> void:
	if animacion.has_animation(nombre):
		if animacion.current_animation != nombre or not animacion.is_playing():
			animacion.play(nombre)
