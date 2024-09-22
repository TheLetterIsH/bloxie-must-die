extends TouchScreenButton


func _ready() -> void:
	var shape := self.shape as RectangleShape2D
	shape.size = get_viewport_rect().size
