extends Control

@onready var textLabel := $Panel/Cont/Label
@onready var textNote := ""

func _ready() -> void:
	self.visible = false

func recieve_text(text) -> void:
	self.visible = true
	textNote = text
	#TextL.text = text
	pass
	
func reset_readingman() -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().parent.realese_movement() 
		self.visible = false
