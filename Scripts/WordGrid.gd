extends VBoxContainer

var current_row: int = 1
var total_rows: int = DATA.get_answer_length()

func _input(event: InputEvent):
	
	#Sets row_node to currently active instance of Row
	var row_node: Node = get_node("Row" + str(current_row))
	
	#Triggers if word is correct - calls xxx in Row.gd
	if (event.as_text() == "Enter"
		and row_node.is_row_full() 
		and row_node.guessed_word == DATA.answer):
			row_node.assess_guess()
		
	#Triggers if word is incorrect.
	elif (event.as_text() == "Enter"
		and row_node.is_row_full() 
		and row_node.guessed_word != DATA.answer):
			
			#Assesses guess and colours accordingly
			row_node.assess_guess()
			
			if current_row == total_rows:
				#Finish game
				pass
			
			elif current_row < total_rows:
				
				#Move on to next row & initalise
				current_row += 1
				row_node = get_node(get_row_name(current_row))
				
				#Set active_row to current_row in all instances of Row
				set_active_row(current_row)
				row_node.initialise()
				
				### TEST - REMOVE
				print("** Moving on to row " + str(current_row) + " **") 
				

func set_active_row(row_num : int):
	#Loops through all children (rows) to set active_row in each Row instance.
	#If not changed in each instance, previously used instances may still 
	#think they are the active row... which would cause Bad Things to happen.
	for n in get_children():
		n.active_row = get_row_name(row_num)

func get_row_name(row_num : int):
	var row_name = "Row" + str(current_row)
	return row_name
