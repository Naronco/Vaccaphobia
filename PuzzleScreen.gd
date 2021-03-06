extends Control


export(NodePath) var playerPath


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# interactions
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		for n in self.get_children():
			n.hide()
		
		# Unfreeze player
		if playerPath != null:
			var player = get_node(playerPath)
			player.enable_movement()
	
	
