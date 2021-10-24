extends Area


export var whatToDo = "turn off electricity"


var interactedOnce = false

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
	if body.name == "Player" and not interactedOnce: # hardcoded, whatever
		body.enable_interaction(self)
		
	pass


func _on_Area_body_exited(body):
	if body.name == "Player":
		body.disable_interaction(self)
	
	
	pass # Replace with function body.


func on_player_interact(player):
	print("Player wants to turn off electricity")
	
	
	var sparkles = get_node("/root/Spatial/Level/1og/wohnzimmer/Sparkles")
	var canTurnOff = sparkles.is_visible()
	
	
	if canTurnOff:
		sparkles.hide()
		
		#make lamp passable
		var lamp = get_node("/root/Spatial/Level/1og/wohnzimmer/lamp")
		for n in lamp.get_children():
			lamp.remove_child(n)
			n.queue_free()
		
		var dir_light = get_node("/root/Spatial/DirectionalLight")
		dir_light.hide()
		
		
		player.disable_interaction(self)
		
		interactedOnce=true
	else:
		#TODO play sound "why should I do this?"
		pass


