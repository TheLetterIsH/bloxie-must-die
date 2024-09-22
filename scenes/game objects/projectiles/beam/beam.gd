extends Node2D

@onready var line: Line2D = $Line2D
@onready var ray_cast: RayCast2D = $RayCast2D

func _ready() -> void:
	var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(line, "width", 4.0, 0.05).from(0.0)


func _process(delta: float) -> void:
	if ray_cast.is_colliding():
		var collider_owner := ray_cast.get_collider().owner as Node2D
		
		if collider_owner.is_in_group("player"):
			(collider_owner as Player).take_damage()
		
		ray_cast.enabled = false


func destroy():
	var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(line, "width", 0.0, 0.05)
	
	await tween.finished
	
	self.queue_free()


func _on_self_destroy_timer_timeout() -> void:
	destroy()
