extends Node2D
class_name Director

@export var point_scene: PackedScene
@export var enemy_scenes: Dictionary
@export var enemy_colors: Dictionary
@export var enemy_spawn_indicator_scene: PackedScene

var wave: int = 1
var wave_duration: float = 24.0

var wave_to_points: Dictionary = {}
var enemy_to_points: Dictionary = {}
var enemy_spawn_chances: Dictionary = {}

var enemies: Array = []
var enemy_spawn_times: Array = []

var wave_time: float = 0.0
var index: int = 0

var time_before_spawning_enemy: float = 1.0

@onready var wave_timer: Timer = $WaveTimer


func _ready() -> void:
	randomize()
	set_wave_to_points()
	set_enemies_to_points()
	set_enemy_spawn_chances()
	set_enemies_for_current_wave()
	spawn_point()


func _process(delta: float) -> void:
	wave_time += delta
	
	if index >= len(enemy_spawn_times):
		return
	
	if wave_time >= enemy_spawn_times[index]:
		spawn_enemy(enemies[index])
		index += 1


func spawn_point() -> void:
	var point_instance := point_scene.instantiate()
	point_instance.global_position = get_random_spawn_position()
	ObjectManager.get_collectible_container().add_child(point_instance)


func spawn_enemy(enemy_type: String) -> void:
	print(str(index) + ": " + str(wave_time) + ", " + enemy_type)
	
	var spawn_position := get_random_spawn_position()
	
	var enemy_spawn_indicator_instance := enemy_spawn_indicator_scene.instantiate() as Node2D
	enemy_spawn_indicator_instance.global_position = spawn_position
	enemy_spawn_indicator_instance.modulate = enemy_colors[enemy_type]
	ObjectManager.get_effects_container().add_child(enemy_spawn_indicator_instance)
	
	await get_tree().create_timer(time_before_spawning_enemy).timeout
	
	var enemy_instance := (enemy_scenes[enemy_type] as PackedScene).instantiate() as Area2D
	enemy_instance.global_position = spawn_position
	ObjectManager.get_enemy_container().add_child(enemy_instance)
	enemy_instance.color = enemy_colors[enemy_type]


func set_wave_to_points() -> void:
	wave_to_points[1] = 16
	for i in range(2, 64, 4):
		wave_to_points[i] = wave_to_points[i - 1] + 8
		wave_to_points[i + 1] = wave_to_points[i]
		wave_to_points[i + 2] = floor(wave_to_points[i + 1] / 1.5)
		wave_to_points[i + 3] = floor(wave_to_points[i + 2] * 2)


func set_enemies_to_points() -> void:
	enemy_to_points = {
		"Shooter": 1,
		"Burster": 2,
		"Waver": 4,
		"Quadnade": 4,
		"Blaster": 4,
		"Laser": 8,
		"Octanade": 8,
		"Bouncer": 16,
	}


func set_enemy_spawn_chances() -> void:
	enemy_spawn_chances = {
		1: ChanceList.new([["Octanade", 4]]),
		2: ChanceList.new([["Shooter", 4], ["Burster", 1]]),
		3: ChanceList.new([["Shooter", 4], ["Burster", 4]]),
		4: ChanceList.new([["Shooter", 2], ["Burster", 1]]),
		5: ChanceList.new([["Shooter", 2], ["Burster", 4], ["Waver", 2]]),
		6: ChanceList.new([["Shooter", 3], ["Burster", 4], ["Waver", 3]]),
		7: ChanceList.new([["Shooter", 4], ["Burster", 4], ["Waver", 4]]),
		8: ChanceList.new([["Shooter", 3], ["Burster", 6], ["Blaster", 4]]),
		9: ChanceList.new([["Burster", 3], ["Waver", 4], ["Quadnade", 1]]),
		10: ChanceList.new([["Burster", 8], ["Waver", 2], ["Quadnade", 2]]),
		11: ChanceList.new([["Waver", 2], ["Blaster", 4], ["Quadnade", 3]]),
		12: ChanceList.new([["Shooter", 2], ["Waver", 2], ["Blaster", 3], ["Quadnade", 2]]),
		13: ChanceList.new([["Burster", 6], ["Quadnade", 1], ["Blaster", 1], ["Octanade", 2]]),
		14: ChanceList.new([["Burster", 3], ["Quadnade", 4], ["Octanade", 2], ["Laser", 1]]),
		15: ChanceList.new([["Waver", 3], ["Blaster", 3], ["Octanade", 3], ["Laser", 3]]),
		16: ChanceList.new([["Burster", 4], ["Blaster", 4], ["Octanade", 2], ["Laser", 4]]),
	}
	
	for i in range(17, 66):
		enemy_spawn_chances[i] = ChanceList.new([
			["Shooter", randi_range(1, 8)],
			["Burster", randi_range(1, 8)],
			["Waver", randi_range(1, 8)],
			["Quadnade", randi_range(1, 8)],
			["Blaster", randi_range(1, 8)],
			["Laser", randi_range(1, 8)],
			["Octanade", randi_range(1, 8)],
			["Bouncer", randi_range(1, 8)],
		])


func set_enemies_for_current_wave() -> void:
	var points := wave_to_points[wave] as int
	
	enemies.clear()
	while points > 0:
		var enemy := (enemy_spawn_chances[wave] as ChanceList).get_random_element() as String
		points -= enemy_to_points[enemy]
		enemies.append(enemy)
	
	enemy_spawn_times.clear()
	for i in range(len(enemies)):
		enemy_spawn_times.insert(i, randf_range(0, wave_duration))
	
	enemy_spawn_times.sort()


func increment_wave() -> void:
	wave += 1
	
	# emit signal for increment wave
	
	wave_time = 0.0
	index = 0


func get_random_spawn_position() -> Vector2:
	var position_x := randf_range(-176, 176)
	var position_y := randf_range(-144, 144)
	
	return Vector2(position_x, position_y)


func _on_wave_timer_timeout() -> void:
	increment_wave()
	set_enemies_for_current_wave()
