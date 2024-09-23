extends Button
class_name BetterButton

@export var color: Color

var hover_color: Color = "#EBEBEB"


func _ready() -> void:
	self.modulate = color


func perform_effects() -> void:
	pivot_offset = Vector2(size.x / 2, size.y / 2)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(1.35, 1.35), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	SoundManager.play_ui_sound_with_pitch(ResourceHolder.sound_button_hover, randf_range(1.2, 1.6), "UI")


func _on_mouse_entered() -> void:
	self.modulate = hover_color
	perform_effects()


func _on_mouse_exited() -> void:
	self.modulate = color
