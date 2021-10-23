extends KinematicBody



# How fast the player moves in meters per second.
export var speed = 2
export var gravity = 9.81

var velocity = Vector3.ZERO

# Hardcoded rotation angles, replace with values from camera node
var _camX = -45.0*PI/180
var _camY = 45.0*PI/180

export var camOffs = Vector3(10/sqrt(2), 5.5, 10/sqrt(2))



# current rotation angle
var curPhi = 0
var targetPhi = 0
export var lerpSpeed = 10

var flashlightAngle = 0
var flashlightAngleCur = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentInteractable = null


export(NodePath) var interactLabelPath


var movement_enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func lerp_angle(from, to, weight):
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference

# framerate-independent lerping
func damp_angle(from, to, lambda, dt):
	return lerp_angle(from, to, 1 - exp(-lambda * dt))
	

func enable_movement():
	movement_enabled = true

func disable_movement():
	movement_enabled = false


func _physics_process(delta):

	var cam = get_node("../Camera")
	var rot = get_node("Rotation")
	var light = get_node("Rotation/FlashLight")
	
	var right = cam.transform.basis.x
	var up = cam.transform.basis.y
	var forward = cam.transform.basis.z

	# project forward on (x,z)-plane
	var planeForward = forward
	planeForward.y = 0
	planeForward = planeForward.normalized()

	# project right on (x,z)-plane
	var planeRight = right
	planeRight.y = 0
	planeRight = planeRight.normalized()

	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	

	if movement_enabled:
		
		# We check for each move input and update the direction accordingly.
		if Input.is_action_pressed("move_right"):
			direction += planeRight
		if Input.is_action_pressed("move_left"):
			direction -= planeRight
		if Input.is_action_pressed("move_down"):
			direction += planeForward
		if Input.is_action_pressed("move_up"):
			direction -= planeForward

		light.transform.basis = Basis(Vector3(1, 0, 0), -PI/4)
		
		var lockAngle = Input.is_action_pressed("strafe")
		
		if direction != Vector3.ZERO and not lockAngle:
			direction = direction.normalized()
			
			# Direction to angle
			targetPhi = 0.5*PI + atan2(direction.z, direction.x)
			
			flashlightAngle = -PI/4

		else:
			flashlightAngle = 0
			
			
			
		# Rotate player accordingly
		curPhi = damp_angle(curPhi, targetPhi, lerpSpeed, delta)
		flashlightAngleCur = damp_angle(flashlightAngleCur, flashlightAngle, lerpSpeed, delta)
		
		rot.transform = self.get_parent().transform.rotated(Vector3(0, 1, 0), -curPhi)
		light.transform.basis = Basis(Vector3(1, 0, 0), flashlightAngleCur)
	
		# Update sprite
		var t=-(targetPhi-0.75*PI-0.125*PI)/(2*PI)
		while t > 1.0:
			t-=1.0
		while t < 0.0:
			t+=1.0
		$Sprite3D.region_rect.position.x=283*(int(round(8*t))%8)
	
	# Ground velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	#var on_steep = false
	#for i in get_slide_count():
	#	var collision = get_slide_collision(i)
	#	if collision.normal.dot(Vector3.UP) < 0.5: # TODO: make less arbitrary
	#		on_steep = true
	#		break # no need to check the rest of the slopes

	#if not is_on_floor() or on_steep:
	#	# Vertical velocity
	#	velocity.y -= gravity * delta

	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, 60.0/180.0*PI)
	velocity.y = -0.01
	
	# place player on floor
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(self.transform.origin + Vector3(0, 1.3, 0), self.transform.origin + Vector3(0, -100, 0))
	
	var rad = get_node("CollisionShape").shape.get_radius()
	
	#print(is_on_floor())
	
	if not is_on_floor() and result:
		#print("Hit at point/normal: ", result.position, result.normal)
		#transform.origin = result.position + rad*result.normal
		transform.origin = result.position + Vector3.UP*rad*(1/result.normal.y-1)
		
	
	# update cam pos
	var camPos = transform.origin + 1.3*Vector3.UP + camOffs
	
	var f=camPos.dot(forward)
	var u=camPos.dot(up)
	var r=camPos.dot(right)
	
	# camPos==f*forward+u*up+r*right
	
	
	var world2Screen=get_viewport().size.y/(2*cam.size)
	
	# quantize r,u
	var s=world2Screen
	r = floor(r*s)/s
	u = floor(u*s)/s
	
	camPos=f*forward+u*up+r*right
	cam.transform.origin=camPos
	
	# Hide/show level parts
	var tutorialRoom = get_node("/root/Spatial/Level")
	var flurOben = get_node("/root/Spatial/Level/flur_oben")
	
	if transform.origin.y > 2.5-1.8:
		flurOben.show()
	else:
		flurOben.hide()
	
	
# interactions
func _input(event):
	if currentInteractable != null:
		if event.is_action_pressed("interact"):
			print("Action pressed !")
			# TODO interaction
			currentInteractable.on_player_interact(self)
	
	

func enable_interaction(interactable: Node):
	print("Entered interaction area of ", interactable)
	print("Press E to interact with ", interactable) # TODO replace with proper UI
	currentInteractable = interactable
	
	if interactLabelPath != null:
		var interactLabel = get_node(interactLabelPath)
		interactLabel.text = "Press E to " + interactable.whatToDo
		interactLabel.show()
		


func disable_interaction(interactable: Node):
	if interactLabelPath != null:
		var interactLabel = get_node(interactLabelPath)
		interactLabel.hide()
	
	currentInteractable = null
	print("Left interaction area of ", interactable)

