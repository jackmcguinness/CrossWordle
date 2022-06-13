extends VBoxContainer





var num_rows: int = 0
var num_cols: int = 0

const HORIZONTAL = "h"
const VERTICAL = "v"


func _ready():
	
#	print("Blank text is: ", $CrossRow1/LetterBox1/Letter.text, "| |")
	
	#Currently working with a 7x7 CrossGrid -- in future this will size
	#automatically based on the length of the longest word in the crossword
	num_rows = 7
	num_cols = 7
	
	#TODO: setup crossgrid with nodes (currently not done programatically)
	
	#Generate cross grid
	generate_cross_grid()


func generate_cross_grid():
	
	var orientation = HORIZONTAL
	var word_length = 5 #Temporary - value will be randomly assigned in future 
	
	# Each word generation returns an array with the below values:
	# word_info[0] = row word begins on 
	# word_info[1] = column word begins on
	# word_info[2] = position of cross point (relative to start of word)
	# word info[3] = letter to be crossed
	
	var word_info = generate_first_word(orientation, word_length)
	
	#TODO: 
	#   Loop the below orientate/generate process until some end-of-algorithm 
	#   criteria (no. words in grid, space available etc). Once criteria is met, 
	#   grossgrid will be full, the loop can finish and the game can begin.
	
	orientation = orientation_flip(orientation)
	word_info   = generate_next_word(orientation, word_info, word_length)

func generate_first_word(orientation: String, word_length: int):

	var start_col = 1 #column to start writing word
	
	#Generate random word
	var word = DATA.generate_answer_word(word_length)
	print("horizontal: ", word) #debug
	
	#Pick a random row
	var row = random_int(1, num_rows)
	write_word_to_grid(orientation, row, word, start_col)
	
	#Pick a random letter in word to cross the next word over
	var cross_pos = random_int(1, word_length)
	var cross_letter = get_crosspoint_letter(cross_pos, orientation, row, 1)
	print("Cross pos = ", cross_pos, "; Cross letter = ", cross_letter) #debug
	
	return [row, start_col, cross_pos, cross_letter]

func generate_next_word(orientation: String, word_info: Array, word_length: int):
	
	#Array elements defined here for readability
	var prev_row: int        = word_info[0]
	var prev_col: int        = word_info[1]
	var cross_pos:int        = word_info[2]
	var cross_letter: String = word_info[3]
	
	#Initialise variables for while loop
	var start_row:    int = 0
	var end_row:      int = 0
	var word_found:  bool = false
	var new_word:  String = ""
	var loop_count:   int = 0
	
	while word_found == false:
		#Find a word containing cross_letter
		new_word = find_word_to_cross(cross_letter, word_length)
		print("vertical: ", new_word) #debug
		
		var overlay_pos:  int  = 0
		var letter_count: int  = 0
		
		for letter in new_word:
			#Loops through new_word to perform checks on each cross_letter in word.
			
			if word_found:
				break
			
			if letter == cross_letter:
				#overlay_pos is position of letter in new_word, NOT prev word
				overlay_pos = letter_count
				
				start_row = prev_row - overlay_pos
				end_row   = prev_row + (new_word.length() - overlay_pos - 1)
				
				print ("Start row: ", start_row, "; End row = ", end_row) #debug
				
				if start_row > 0 and end_row <= num_rows:
					print("word found!: ", new_word) #debug
					word_found = true
			
			letter_count += 1
		
		#Loop counter - used for debugging
		loop_count += 1
		if loop_count > 1:
			print(loop_count, " words evaluated")
	
	
	#Write word vertically into crossgrid
	var col_to_write_to = prev_col + cross_pos - 1 
	
	write_word_to_grid(orientation, col_to_write_to, new_word, start_row)

func write_word_to_grid(orientation, start_col_or_row, word, start_pos):
	if orientation == HORIZONTAL:
		write_to_row(start_col_or_row, word, start_pos)
	elif orientation == VERTICAL:
		write_to_col(start_col_or_row, word, start_pos)

func write_to_col(col_num, word, start_row):
	for n in word.length():
		var crossrow_node = get_crossrow_node(n + start_row)
		
		var letter: String = word.substr(n, 1)
		var letterbox_node: Node = crossrow_node.get_node(get_letterbox_name(col_num))
		
		if letterbox_node.get_node("Letter").text != letter:
			letterbox_node.get_node("Letter").text = letter 

func write_to_row(row_num, word, start_col):
	var crossrow_node = get_crossrow_node(row_num)
	
	#Write in a word horizotally starting at column 'start_pos'
	for n in word.length():
		var letter: String = word.substr(n, 1)
		var letterbox_node: Node = crossrow_node.get_node(get_letterbox_name(start_col + n))
		letterbox_node.get_node("Letter").text = letter 

func get_crosspoint_letter(cross_point, h_or_v, starting_row, starting_col):
	if h_or_v == HORIZONTAL:
		var crossrow_node_name: String = get_crossrow_name(starting_row)
		var crossrow_node: Node        = get_node(crossrow_node_name)
		
		var letter_to_cross: int   = cross_point + starting_col - 1
		var letterbox_name: String = get_letterbox_name(letter_to_cross)
		var letterbox_node: Node   = crossrow_node.get_node(letterbox_name)
		
		return letterbox_node.get_node("Letter").text
	
	elif h_or_v == VERTICAL:
		#TODO: write this after vertical writing is implemented
		pass

func find_word_to_cross(letter_to_cross, word_length):
	var new_word = ""
	var word_contains_letter = false
	
	var word_array = DATA.read_word_file(word_length)
	
	while (word_contains_letter == false): 
		var word_array_size = word_array.size()
		var i = random_int(0, word_array.size()) - 1
		new_word = word_array[i]
		
		if letter_to_cross in new_word:
			word_contains_letter = true
	
	return new_word

func orientation_flip(orientation):
	if orientation == HORIZONTAL:
		orientation = VERTICAL
	elif orientation == VERTICAL:
		orientation = HORIZONTAL
	
	return orientation

func random_int(lower, upper):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(lower, upper)

func get_crossrow_name(row: int):
	return "CrossRow" + str(row)

func get_crossrow_node(row_num):
	var crossrow_name: String = get_crossrow_name(row_num)	
	var crossrow_node: Node = get_node(crossrow_name)
	return crossrow_node

func get_letterbox_name(letterbox: int):
	var letterbox_name = "LetterBox" + str(letterbox)
	return letterbox_name
