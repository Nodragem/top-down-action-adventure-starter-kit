extends Node

signal health_changed(old_value, new_value)
signal damage
signal health_depleted
signal health_replenished

@export var ui_hearts: Array[TextureRect]
@export var max_health: int = 6
@export var start_health: int = 6

var heart_full = preload("res://assets/objects/heart_full.png")
var heart_empty = preload("res://assets/objects/heart_null.png")
var heart_half = preload("res://assets/objects/heart_half.png")

var health_points: int = 0: set = set_health

func _ready():
	health_points = start_health

func set_health(value:int):
	health_changed.emit(health_points, value)
	health_points = value
	update_ui_hearts(health_points)
	if health_points <= 0:
		health_depleted.emit()
	if health_points == max_health:
		health_replenished.emit()

func update_ui_hearts(value):
	for i in len(ui_hearts):
		if value > i * 2 + 1:
			ui_hearts[i].texture = heart_full
		elif value > i * 2:
			ui_hearts[i].texture = heart_half
		else:
			ui_hearts[i].texture = heart_empty

func get_damage(amount:int):
	health_points = max(0, health_points - amount)
	damage.emit()

func get_health(amount:int):
	health_points = min(max_health, health_points + amount)

func get_full_health():
	health_points = max_health

func instant_death():
	health_points = 0
