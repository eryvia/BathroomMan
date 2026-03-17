class_name Door
extends Interactable

@export var item_id: String
@export var velocity := 200

@onready var pointer = $Marker3D

func _ready():
	interaction_label = "Pick up"
	is_enabled = true

func interact(player) -> void:
	pass
