extends Control

@onready var VBOXc = $Panel/VBoxContainer
@onready var selections = []
var currecnt_selection = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selections = VBOXc.get_children().lowercase()
	
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		_get_game_scene(currecnt_selection)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_game_scene(selected): 
	if selected in selections:
		pass
