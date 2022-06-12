extends VBoxContainer





var num_rows: int = 0
var num_cols: int = 0

const HORIZONTAL = "h"
const VERTICAL = "v"


func _ready():
	
	#Currently working with a 7x7 CrossGrid -- in future this will size
	#automatically based on the length of the longest word in the crossword
	num_rows = 7
	num_cols = 7
	
	#TODO: setup crossgrid with nodes (currently not done programatically)
	
	#Generate cross grid
	generate_cross_grid()



func generate_cross_grid():
	 
	# ---------  FIRST WORD  --------- #
	
	var orientation = HORIZONTAL
	
	var word_length = 5 #Temporary - value will be randomly assigned in future
	
	#Pick a random row
	var row = random_int(1, num_rows)
	write_to_row(row, word_length)

	
	#Pick a random letter in word
	var cross_pos = random_int(1, word_length)
	var cross_letter = get_crosspoint_letter(cross_pos, orientation, row, 1)
	print("Cross pos = ", cross_pos, "; Cross letter = ", cross_letter)
	
	# ---------  SECOND WORD  --------- #
	
	orientation = VERTICAL
	
	#Find a word with cross_letter in
	var new_word = find_word_to_cross(cross_letter, word_length)
	print(new_word)
	
	#Can word fit in the grid?	
		#Yes - write in
		#No - find another word
	
	#find the position of cross letter in new word (overlay_pos)
	#for writing vertically, 
		#start pos = row - overlay_pos
		#end pos = row + (new_word.lenth() - overlay_pos)
	#if start pos is less than 1 or end pos is greater than num crossrows, word cannot fit in grid and new word needed
	#else write in word 
	
	
	
	
	#Write in a word vertically: write_to_col(cross_point, word_length)
	



func write_to_row(row_num, word_length):
	var crossrow_node = get_crossrow_node(row_num)
	
	#Generate random word
	var word = DATA.generate_answer_word(word_length)
	
	#Write in a word horizotally starting at column 1
	for n in word.length():
		var letter: String = word.substr(n, 1)
		var letterbox_node: Node = crossrow_node.get_node(get_letterbox_name(n+1))
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
		#TODO: write this when vertical writing is implemented
		pass

func find_word_to_cross(letter_to_cross, word_length):
	var new_word = ""
	var word_contains_letter = false
	
	var word_array = DATA.read_word_file(word_length)
	
	while (word_contains_letter == false): 
		var i = random_int(0, word_array.size())
		new_word = word_array[i]
		
		if letter_to_cross in new_word:
			word_contains_letter = true
	
	return new_word

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
