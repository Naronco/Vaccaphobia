extends Control

export var maxSlots=6

var items = [0,0,0,0,0,0]


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Inventory_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var slot=int(floor(event.position.y/32))
		if slot < maxSlots:
			print("click on slot", slot)
	
	pass # Replace with function body.
