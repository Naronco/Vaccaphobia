extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var unlockItemId = 3

var activated=false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LampFallArea_body_entered(body):
	if activated:
		return
	
	if body.name == "Player": # hardcoded, whatever
		var inventory = get_node("/root/Spatial/MarginContainer/CanvasLayer/Inventory")
		
		#if true:
		if inventory.contains(unlockItemId):
			# TODO play sound effect
			var lamp = get_node("/root/Spatial/Level/1og/wohnzimmer/lamp")
			lamp.transform.basis = Basis(Vector3(0, 0, 1), -86.0*PI/180)
			lamp.transform.origin.x -= 0.5
			lamp.transform.origin.y += 0.148
			
			var sparkles = get_node("/root/Spatial/Level/1og/wohnzimmer/Sparkles")
			sparkles.show()
			
			var sparklesAudio = get_node("/root/Spatial/Level/1og/wohnzimmer/Sparkles/AudioStreamPlayer3D")
			sparklesAudio.play()
			
			$AudioStreamPlayer3D.play()
			
			activated = true
			


func _on_LampFallArea_body_exited(body):
	if body.name == "Player": # hardcoded, whatever
		var inventory = get_node("/root/Spatial/MarginContainer/CanvasLayer/Inventory")
