extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var cloneNode

var grid = []
var clicked = []

var preset = [5, 7, 10, 11]

var gotKey = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = get_node(cloneNode)
	for y in range(4):
		for x in range(4):
			var d = n.duplicate()
			d.rect_position.x += x * 80.0
			d.rect_position.y -= y * 45.0
			grid.append(d)
			clicked.append(false)
			if preset.find(x + y * 4) != -1:
				toggle(x + y * 4)
			d.connect("gui_input", self, "_click_schublade", [x + y * 4])
			add_child(d)
	n.hide()

func _click_schublade(event, i):
	if gotKey:
		return
	
	if event is InputEventMouseButton and event.pressed:
		var y = floor(i / 4)
		var x = i % 4
		toggle(i)
		if x > 0:
			toggle(i - 1)
		if y > 0:
			toggle(i - 4)
		if x < 3:
			toggle(i + 1)
		if y < 3:
			toggle(i + 4)

func toggle(i):
	if clicked[i]:
		clicked[i] = false
		grid[i].get_child(0).show()
		grid[i].get_child(1).hide()
	else:
		clicked[i] = true
		grid[i].get_child(0).hide()
		grid[i].get_child(1).show()
		
	for i in range(4 * 4):
		if clicked[i]:
			return
			
	gotKey = true
	var inventory = get_node("/root/Spatial/MarginContainer/CanvasLayer/Inventory")
	inventory.add(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
