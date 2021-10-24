extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var successID = 2
var failID = 3

var success = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LineEdit_text_entered(new_text):
	if success:
		return
	
	if new_text == "3110" or new_text == "1031":
		get_child(successID).show()
		get_child(failID).hide()
		success = true
	else:
		get_child(failID).show()
