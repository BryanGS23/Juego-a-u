
extends Control

@onready var reintentar: Button = $CenterContainer/VBoxContainer/Button
@onready var menu: Button = $CenterContainer/VBoxContainer/Button2

func _ready() -> void:
	reintentar.pressed.connect(reiniciar_nivel)
	menu.pressed.connect(ir_menu)

func reiniciar_nivel() -> void:
	cambiar_escena("res://escenas/cascadas.tscn")

func ir_menu() -> void:
	cambiar_escena("res://escenas/niveles.tscn")

func cambiar_escena(ruta: String) -> void:
	var resultado = get_tree().change_scene_to_file(ruta)

	if resultado != OK:
		push_error("No se pudo abrir: " + ruta)
