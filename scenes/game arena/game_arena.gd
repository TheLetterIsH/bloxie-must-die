extends Node2D

@export var mobile_controls_canvas_layer: PackedScene


func _ready() -> void:
	if OS.get_name() == "Android":
		self.add_child(mobile_controls_canvas_layer.instantiate())
