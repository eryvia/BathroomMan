class_name God
extends Interactable

var lines = ["hello, human..", "dawd"]
var label = ["just a old dude", "talk to"]

func _ready():
	interaction_label = "Talk to"
	name_index = "God"

func interact(player) -> void:
	DialogueManager.start_dialogue(lines, name_index)
	#SignalBus.start_dialogue.emit(self, player)
	pass

func get_label() -> String:
	return interaction_label
