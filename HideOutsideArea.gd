extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HideOutsideArea_body_entered(body):
	if body.name == "Player": # hardcoded, whatever
		var outside = get_node("/root/Spatial/Level/outside")
		outside.hide()


func _on_HideOutsideArea_body_exited(body):
	if body.name == "Player": # hardcoded, whatever
		var outside = get_node("/root/Spatial/Level/outside")
		outside.show()
