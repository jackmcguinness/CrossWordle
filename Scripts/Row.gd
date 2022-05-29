extends HBoxContainer

var letter_to_update: int = 1
var guessed_word: String = ""
var active_row = "Row1"

func _ready():
	
	add_letterboxes_to_row()
	

	


func initialise():
	letter_to_update = 1
	guessed_word = ""

func _input(event : InputEvent):
	#Don't leave anything outside of event checks in this routine!! 
	#Or it will trigger for every single mouse and keyboard input.
	
	#Returns out of _input() unless Row instance is the currently active row, so
	#only the currently active Row instance is updated on input.
	#active_row is set in WordGrid _input().
	if name != active_row:
		return
	
	#Letter Input
	if is_input_a_letter(event) == true:
		if (letter_to_update <= DATA.get_answer_length()):
			
			#Add letter to LetterBox UI
			var node_name: String = get_letterbox_name(letter_to_update)
			get_node(node_name).get_node("Letter").text = get_input_letter(event)
			
			#Apend letter to guess string
			guessed_word = guessed_word + get_input_letter(event)
			
			#Move letter_to_update to next LetterBox
			if letter_to_update <= DATA.get_answer_length():
				letter_to_update += 1
			
			print(node_name, "; " , guessed_word , ", " , letter_to_update)
		
	#BackSpace Input
	elif is_input_a_letter(event) == false:
		if get_nonletter_input(event) == "BackSpace" and letter_to_update > 1:
			#Move letter_to_update to previous LetterBox
			letter_to_update -= 1
			
			#Remove letter from LetterBox UI
			var node_name: String = get_letterbox_name(letter_to_update)
			get_node(node_name).get_node("Letter").text = ""
			
			#Remove letter from guess string
			guessed_word.erase(guessed_word.length() - 1, 1)
			
			print(node_name, "; " , guessed_word , ", " , letter_to_update)
			

func compare_letters():
	
	#First loop checks for greens and sets all other letterboxes grey:
	for n in DATA.answer.length():
		var guessed_letter_n : String = guessed_word.substr(n, 1)
		var answer_letter_n  : String = DATA.answer.substr(n, 1)
		var letterbox_n      : Node = get_node(get_letterbox_name(n+1))
		
		#If guessed letter is in the correct place:
		if guessed_letter_n == answer_letter_n:
			letterbox_n.set_colour_green()
		else:
			letterbox_n.set_colour_grey()
		
	#Second loop checks for yellows and overwrites grey with yellow:
	for n in DATA.answer.length():
		var guessed_letter_n : String = guessed_word.substr(n, 1)
		var answer_letter_n  : String = DATA.answer.substr(n, 1)
		var letterbox_n      : Node = get_node(get_letterbox_name(n+1))
		
		#If letter appears in word, but is in the wrong place
		if (guessed_letter_n != answer_letter_n
			and guessed_letter_n in DATA.answer):
				#If letter only appears once, check if it is already green
				#(i.e. is it already in the correct place), and set grey if so.
				#
				#Otherwise, letter is in the answer but not in the correct 
				#place - so if there are less as many letters in the guess so 
				#far, set yellow. If there are more instances of a letter in 
				#the guess than in the answer, the remainder are set to grey.
				#
				#e.g. for 'BALLS', guess 'LLXXL' would have the first 2 'L's 
				#yellow, and the third grey, as there are only 2 'L's in answer.
				
				var ans_letter_pos = DATA.answer.find(guessed_letter_n, 0)
				var letterbox_name = get_letterbox_name(ans_letter_pos + 1)
				
				if get_node(letterbox_name).is_letterbox_green():
					letterbox_n.set_colour_grey()
				else:
					
					var ans_letter_count = DATA.answer.count(guessed_letter_n)
					
					var guess_substr = guessed_word.substr(0, n)
					var guess_letter_count = guess_substr.count(guessed_letter_n)
					
					if guess_letter_count < ans_letter_count:
						letterbox_n.set_colour_yellow()
					else:
						letterbox_n.set_colour_grey()

func add_letterboxes_to_row():
	#WARNING: Row scene starts with 1 LetterBox so it can be seen when 
	#constructing other scenes. The n-th LetterBox scene added by this
	#code will be the n+1-th LetterBox in the Row.
	
	var num_boxes_to_add = DATA.get_answer_length() - 1
	
	for n in num_boxes_to_add:
		var LetterBox_scene = load("res://Scenes/LetterBox.tscn")
		var scene_instance: Node = LetterBox_scene.instance()
		scene_instance.name = "LetterBox"+str(n+2)
		add_child(scene_instance)

func get_input_letter(event):
	#This func is here to call in place of using event.get_text() elsewhere.
	#If event is Backspace or Enter and event.as_text() is passed into 
	#LetterBox.text, the game will get very confused and Bad Things will happen. 
	#Calling this func causes catches non-letter events.
	
	if is_input_a_letter(event):
		return event.as_text()

func get_nonletter_input(event):
	#As above, used to prevent event.as_text() being called for the wrong input.
	#explicitly checks for false as is_input_a_letter can return null.
	
	if is_input_a_letter(event) == false:
		return event.as_text()

func get_letterbox_name(letterbox_num : int):
	#All calls to LetterBox nodes need the node name to be able to call. This
	#is always set up by calling this function, as if the name of the LetterBox
	#nodes change in the future, only this one line will need changing.
	
	var letterbox_name = "LetterBox" + str(letterbox_num)
	return letterbox_name

func is_row_full():
	#Returns true if row contains a full word, false otherwise.
	#else should (hopefully) never be triggered.
	
	if guessed_word.length() == DATA.get_answer_length():
		return true
	elif guessed_word.length() < DATA.get_answer_length():
		return false
	else:
		print("ERROR: Guessed word has more letters than LetterBoxes!")

func is_input_a_letter(var input : InputEvent):
	#The letter inputs are hardcoded here for safety.
	#Input data from ALL input devices trigger _input(), so it's safer to have 
	#this return true only for the explicit letter inputs.
	#Func returns null if input is neither letter nor backspace/enter.
	#
	#There is almost certainly a nicer way to do this, but this is safe and
	#bug-free
	
	if input.is_action_pressed("BackSpace") or input.is_action_pressed("Enter"):
		return false
	elif input.is_action_pressed("A"):
		return true
	elif input.is_action_pressed("B"):
		return true
	elif input.is_action_pressed("C"):
		return true
	elif input.is_action_pressed("D"):
		return true
	elif input.is_action_pressed("E"):
		return true
	elif input.is_action_pressed("F"):
		return true
	elif input.is_action_pressed("G"):
		return true
	elif input.is_action_pressed("H"):
		return true
	elif input.is_action_pressed("I"):
		return true
	elif input.is_action_pressed("J"):
		return true
	elif input.is_action_pressed("K"):
		return true
	elif input.is_action_pressed("L"):
		return true
	elif input.is_action_pressed("M"):
		return true
	elif input.is_action_pressed("N"):
		return true
	elif input.is_action_pressed("O"):
		return true
	elif input.is_action_pressed("P"):
		return true
	elif input.is_action_pressed("Q"):
		return true
	elif input.is_action_pressed("R"):
		return true
	elif input.is_action_pressed("S"):
		return true
	elif input.is_action_pressed("T"):
		return true
	elif input.is_action_pressed("U"):
		return true
	elif input.is_action_pressed("V"):
		return true
	elif input.is_action_pressed("W"):
		return true
	elif input.is_action_pressed("X"):
		return true
	elif input.is_action_pressed("Y"):
		return true
	elif input.is_action_pressed("Z"):
		return true
	else: #Just here for clarity: would stil return null here if removed
		return null 


