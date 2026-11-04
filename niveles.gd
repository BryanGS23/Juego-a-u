
extends Control

@onready var nivel1: Button = $CenterContainer/VBoxContainer/Button
@onready var volver: Button = $CenterContainer/VBoxContainer/Button2

func _ready() -> void:
	nivel1.pressed.connect(abrir_nivel1)
	volver.pressed.connect(volver_pueblo)

func abrir_nivel1() -> void:
	cambiar_escena("res://escenas/pueblo.tscn")

func volver_pueblo() -> void:
	cambiar_escena("res://escenas/cascadas.tscn")

func cambiar_escena(ruta: String) -> void:
	var resultado = get_tree().change_scene_to_file(ruta)

	if resultado != OK:
		push_error("No se pudo abrir: " + ruta)
