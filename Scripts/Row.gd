extends HBoxContainer

var letter_to_update: int = 1
var guessed_word: String = ""
var active_row = "Row1"

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
			var node_name: String = get_letterbox_name(letter_to_update)
			get_node(node_name).get_node("Letter").text = ""
			
			#Remove letter from guess string
			guessed_word.erase(guessed_word.length() - 1, 1)
			
			print(node_name, "; " , guessed_word , ", " , letter_to_update)
			

func compare_letters():
	
	for n in DATA.answer.length():
		var guessed_letter_n : String = guessed_word.substr(n, 1)
		var answer_letter_n  : String = DATA.answer.substr(n, 1)
		var letterbox_n      : Node = get_node("LetterBox" + str(n+1))
		
		
		
		#If guessed letter is in the correct place:
		if guessed_letter_n == answer_letter_n:
			letterbox_n.set_colour_green()
		
		#If letter appears in word, but is in the wrong place
		elif (guessed_letter_n != answer_letter_n
			and guessed_letter_n in DATA.answer):
				
				#Create substring of guessed_word from 0 to n.
				var guess_substring : String = guessed_word.substr(0, n+1)
				
				#Count number of times letter occurs in substring
				var letter_count = guess_substring.count(guessed_letter_n, 0)
				
				#Compare against answer - set yellow or grey accordingly
				if letter_count <= DATA.answer.count(guessed_letter_n, 0):
					letterbox_n.set_colour_yellow()
				else:
					letterbox_n.set_colour_grey()
		
		
#		BELOW DOESN'T QUITE WORK YET!!! 
#		If a letter is guessed BEFORE the correct place, it will colour yellow
#		regardless of if the letter is also guessed correctly and turns green.
#		e.g: for answer ABCDE, if guessed CCCCC, the first C will turn yellow 
#		and the third will turn green.
#		
#		SOLUTION: WI think we need to check for greens in a seperate loop before
#		yellows. Then before we colour a box yellow, we can check to see how 
#		many of this letetr are coloured green, and then change the compare if to
#		
#		if letter_count + (no. greens for this letter) <= DATA.answer.count(guessed_letter_n, 0):
#			turn yellow
#
#
#
##		#SOLUTION THAT WILL WORK:
##		1) Create a substring of guessed_word at from 0 to n (e.g. Godot will have substrs 
##		G, GO, GOD, GODO, GODOT). 
##		2) Then for each substr, count the number of times 
##		guessed_letter_n appears.
##		3) Count the number of times guessed_letter_n appears in answer.
##		4) if (2) <= (3), colour yellow. Otherwise colour grey. 
		
			
		else:
			letterbox_n.set_colour_grey()
		


#
#func populate_letter_dictionary():
#	for n in DATA.answer.length():
#		var letter_n : String = guessed_word.substr(n, 1)
#		update_letter_dict(letter_n)

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
	var letterbox_name = "LetterBox" + str(letterbox_num)
	return letterbox_name



func is_row_full():
	#Returns true if row contains a full word, false otherwise.
	
	if guessed_word.length() == DATA.get_answer_length():
		return true
	elif guessed_word.length() < DATA.get_answer_length():
		return false
	else:
		print("ERROR: Guessed word has more letters than LetterBoxes!")


#func initialise_letter_dictionary():
#	#This function sets up the letter dictionary, where the value for each key
#	#is the number of times the letter appears in the guessed word.
#	#
#	#The below list is necessary to declare the dictionary keys (A-Z).
#	#This function can be called to reset the values, but the dict can also be 
#	#looped through.
#	#letter_count.size() can be used to get/set size if necessary.
#
#	letter_count["A"] = 0
#	letter_count["B"] = 0
#	letter_count["C"] = 0
#	letter_count["D"] = 0
#	letter_count["E"] = 0
#	letter_count["F"] = 0
#	letter_count["G"] = 0
#	letter_count["H"] = 0
#	letter_count["I"] = 0
#	letter_count["J"] = 0
#	letter_count["K"] = 0
#	letter_count["L"] = 0
#	letter_count["M"] = 0
#	letter_count["N"] = 0
#	letter_count["O"] = 0
#	letter_count["P"] = 0
#	letter_count["Q"] = 0
#	letter_count["R"] = 0
#	letter_count["S"] = 0
#	letter_count["T"] = 0
#	letter_count["U"] = 0
#	letter_count["V"] = 0
#	letter_count["W"] = 0
#	letter_count["X"] = 0
#	letter_count["Y"] = 0
#	letter_count["Z"] = 0
#
#func update_letter_dict(var letter_to_update : String):
#	letter_count[letter_to_update] += 1

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


