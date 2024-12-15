extends Node3D

@export var looking_target:Node3D

func _ready():
	if looking_target:
		var bone_constraint:LookAtTarget = $Skeleton3D/LookAtTarget
		bone_constraint.target = looking_target
