extends Node

@onready var dialogue_text = $Label
var dialogue_index := 0 

func start_dialogue(lines, name): 
	dialogue_text[lines[dialogue_index]]
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("advance_dialogue"):
		pass
