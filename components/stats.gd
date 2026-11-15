extends Node
class_name Stats

@export_group("Settings")
@export var max_hp: int = 100
@export var dmg: int = 5

var hp: int = max_hp:
	set(val):
		hp = clampi(val, 0, max_hp)
