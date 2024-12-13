@tool

class_name LookAtTarget
extends SkeletonModifier3D

@export var target: Node3D
@export_enum(" ") var bone: String:
	set(new_bone):
		bone = new_bone
		update_variables()
var skeleton: Skeleton3D
var bone_idx: int

func update_variables():
	skeleton = get_skeleton()
	if skeleton:
		bone_idx = skeleton.find_bone(bone)
		print("bone index was updated")
	else:
		print("no skeleton!")

func _ready():
	update_variables()

func _validate_property(property: Dictionary) -> void:
	if property.name == "bone":
		var skeleton: Skeleton3D = get_skeleton()
		if skeleton:
			property.hint = PROPERTY_HINT_ENUM
			property.hint_string = skeleton.get_concatenated_bone_names()

func _process_modification() -> void:
	if !skeleton:
		return # Never happen, but for the safety.
	
	var bone_pose: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx)
	
	var looked_at: Transform3D = _y_look_at(bone_pose, target.global_position)
	skeleton.set_bone_global_pose(
		bone_idx, 
		Transform3D(looked_at.basis.orthonormalized(), 
		skeleton.get_bone_global_pose(bone_idx).origin)
	)

func _y_look_at(from: Transform3D, target: Vector3) -> Transform3D:
	var t_v: Vector3 = target - from.origin
	var v_y: Vector3 = t_v.normalized()
	var v_z: Vector3 = Vector3.UP # in our local space Z is up
	var v_x: Vector3 = v_y.cross(v_z)
	from.basis = Basis(v_x, v_y, v_z)

	return from
