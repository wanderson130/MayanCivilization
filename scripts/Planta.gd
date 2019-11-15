extends Node2D

onready var TIMER = $Timer
onready var PROGRESS_BAR = $ProgressBar
onready var ANIM_SPRITE = $AnimatedSprite
var elapsed_time = 0
var starter_time_mark = 0
var current_time_mark = 0
var new_time_mark = 0
var if_counter = 0
var num_frames = 0
var current_frame = 0
var growing_time = 0
var starter_grow_step = 0
var next_grow_step = 0
var aux = -1

func _on_Timer_timeout():
	pass # Replace with function body.

func round_to_dec(num, digit):
    return round(num * pow(10.0, digit)) / pow(10.0, digit)

	
func _ready():
	starter_time_mark = TIMER.wait_time/3.0
	new_time_mark = starter_time_mark
	#current_time_mark = starter_time_mark
	print("starter_time_mark:", starter_time_mark)
	print("wait time:", TIMER.wait_time)
	

func _physics_process(delta):
	#tempo decorrido
	elapsed_time = TIMER.wait_time - TIMER.time_left
	#print("elapsed:", elapsed_time)
	PROGRESS_BAR.value = (elapsed_time*100)/TIMER.wait_time
	
	if(round_to_dec(elapsed_time, 1) == round_to_dec(new_time_mark, 1) and if_counter == 0):
		ANIM_SPRITE.animation = "stage1"
		current_time_mark = new_time_mark
		new_time_mark+=starter_time_mark
		if_counter+=1
		
	if(round_to_dec(elapsed_time, 1) == round_to_dec(new_time_mark, 1) and if_counter == 1):
		ANIM_SPRITE.animation = "stage2"
		current_time_mark = new_time_mark
		new_time_mark+=starter_time_mark
		if_counter+=1
	
	if (ANIM_SPRITE.animation == "stage2"):
		num_frames = ANIM_SPRITE.get_sprite_frames().get_frame_count("stage2")
		starter_grow_step = (new_time_mark - current_time_mark)/num_frames
		next_grow_step = current_time_mark + starter_grow_step
		#print("current_time:", current_time_mark)
		#print("next_grow:", next_grow_step)
		#print("EL:", elapsed_time, "next:", next_grow_step)
		if(round_to_dec(elapsed_time, 1) == round_to_dec(next_grow_step, 1) and aux < num_frames):
			#next_grow_step+=starter_grow_step
			ANIM_SPRITE.set_frame(aux)
			print("growstep", aux)
			aux+=1
			
			

	
	if(round_to_dec(elapsed_time, 1) == round_to_dec(new_time_mark, 1) and if_counter == 2):
		ANIM_SPRITE.animation = "stage3"
	
	