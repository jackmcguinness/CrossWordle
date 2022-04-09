extends HBoxContainer

var letter_to_update: int = 1
var guessed_word: String = ""

func initialise():
	letter_to_update = 1
	guessed_word = ""

func _input(event : InputEvent):
	#Don't leave anything outside of event checks in this routine!! 
	#Or it will trigger for every single mouse and keyboard input.
	
	#Letter Input
	if is_input_a_letter(event) == true:
		if (letter_to_update <= DATA.get_answer_length()):
			
			#Add letter to LetterBox UI
			var node_name: String = "LetterBox" + str(letter_to_update)
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
			var node_name: String = "LetterBox" + str(letter_to_update)
			get_node(node_name).get_node("Letter").text = ""
			
			#Remove letter from guess string
			guessed_word.erase(guessed_word.length() - 1, 1)
			
			print(node_name, "; " , guessed_word , ", " , letter_to_update)
			
	#Enter Input
		if get_nonletter_input(event) == "Enter" and is_row_full():
			#Compare guessed_word with actual answer
			#Deal with colours
			#Move on to next row
			pass


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

func is_row_full():
	#Returns true if row contains a full word, false otherwise.
	
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
	#bug-free... for now
	
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

