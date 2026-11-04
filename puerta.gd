
extends Area2D

@export_file("*.tscn") var escena_destino: String = "res://escenas/niveles.tscn"

var cambiando: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if cambiando:
		return

	if body is CharacterBody2D and body.name == "Player":
		cambiando = true
		print("Jugador detectado")
		cambiar_escena.call_deferred()

func cambiar_escena() -> void:
	print("Escena actual: ", get_tree().current_scene.scene_file_path)
	print("Escena destino: ", escena_destino)

	var resultado = get_tree().change_scene_to_file(escena_destino)

	print("Resultado: ", resultado)
	
	if resultado != OK:
		push_error("No se pudo cargar la escena")
		cambiando = false
	else:
		print("Cambio solicitado correctamente")
