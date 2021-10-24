extends Area


export var openCloseTime = 0.5

var whatToDo = "open door"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var doorOpen = false
var doorInUse = false

var lastOpeningAngle=0
var targetOpeningAngle = 0
var curOpeningAngle = 0
var timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _door_interpolate(a, b, t):
	var steps=3
	var t2=round(t*steps)/steps
	return a+(b-a)*t2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if doorInUse:
		timer+=delta
		if timer >= openCloseTime:
			doorInUse=false
			timer=openCloseTime
			
			if doorOpen:
				whatToDo="close door"
			else:
				whatToDo="open door"

		var t =timer/openCloseTime
		#curOpeningAngle=lastOpeningAngle+(targetOpeningAngle-lastOpeningAngle)*t
		curOpeningAngle=_door_interpolate(lastOpeningAngle, targetOpeningAngle, t)
		
		$Anchor/Mesh.transform.basis = Basis(Vector3.UP, curOpeningAngle)
	


func _on_Area_body_entered(body):
	if body.name == "Player" and not doorInUse: # hardcoded, whatever
		body.enable_interaction(self)
		
	pass


func _on_Area_body_exited(body):
	if body.name == "Player" and not doorInUse:
		body.disable_interaction(self)
	
	
	pass # Replace with function body.


func on_player_interact(player):
	print("Player wants to open a door")
	if doorInUse:
		return
	
	player.disable_interaction(self)
	
	doorInUse = true
	doorOpen = not doorOpen
	
	if doorOpen:
		lastOpeningAngle = 0
		targetOpeningAngle = PI/2
	else:
		lastOpeningAngle = PI/2
		targetOpeningAngle = 0
	
	curOpeningAngle = lastOpeningAngle
	timer = 0
	
	
	pass