extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var imageDuration = 7

var time=0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	
	if time>=imageDuration and time<2*imageDuration:
		$Image1.hide()
		$Image2.show()
	
	pass
