extends Control

export var maxSlots=6

var items = [0,0,0,0,0,0]

var itemDict = [
	null,
	preload("res://assets/gewinde_ding.png"),
	preload("res://assets/knauf.png"),
	preload("res://assets/key.png"),
	preload("res://assets/key.png"),
	preload("res://assets/key.png")
]


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func contains(item):
	return items.find(item) != -1

func add(item):
	var empty = items.find(0)
	if empty == -1:
		return false
	items[empty] = item
	rerender()
	return true

func remove(item):
	var index = items.find(item)
	if index != -1:
		items[index] = 0
		rerender()
		return true
	else:
		return false

func rerender():
	for i in range(maxSlots):
		var item = self.get_child(i).get_child(0)
		item.texture = itemDict[items[i]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Inventory_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var slot=int(floor(event.position.y/32))
		if slot < maxSlots:
			print("click on slot", slot)
	
	pass # Replace with function body.
