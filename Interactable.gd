extends Area


export var whatToDo = "open fuse box"


export(String) var puzzleScreenPath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.name == "Player": # hardcoded, whatever
		body.enable_interaction(self)
		
	pass


func _on_Area_body_exited(body):
	if body.name == "Player":
		body.disable_interaction(self)
	
	
	pass # Replace with function body.


func on_player_interact(player):
	var puzzleScreen = get_node(puzzleScreenPath)
	player.disable_movement()
	puzzleScreen.show()
	
	pass

