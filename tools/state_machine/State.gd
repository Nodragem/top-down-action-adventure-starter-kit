@icon("res://tools/state_machine/state.svg")
class_name State 
extends Node


@onready var _state_machine:StateMachine = _get_state_machine(self) 
var _parent:State = null

signal enter_state
signal exit_state

func _ready() -> void:
	print("State ", self.name, " is waiting for owner ", self.owner.name)
	await self.owner.ready
	print("State Owner ", self.owner.name, " is ready")
	var parent: = get_parent()
	if not parent.is_in_group("state_machine"):
		_parent = parent

func unhandled_input(event: InputEvent) -> void:
	return


func process(delta: float) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: = {}) -> void:
	enter_state.emit()
	return


func exit() -> void:
	exit_state.emit()
	return


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
