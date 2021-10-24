extends Container

export var addToInventory = false
export var needsInventory = false
export var consumesInventory = false
export var inventoryId = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_remove_target_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var inventory = get_node("/root/Inventory")
		if addToInventory:
			inventory.add(inventoryId)
		if needsInventory:
			if not inventory.contains(inventoryId):
				return
			if consumesInventory:
				inventory.remove(inventoryId)
		get_parent().hide()
