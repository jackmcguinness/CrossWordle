extends VBoxContainer

var current_row: int = 1

func _ready():
	
	add_rows_to_wordgrid()

func add_rows_to_wordgrid():
	#WARNING: Grid scene starts with 1 Row so it is visible in the scene  
	#editor. The n-th LetterBox scene added by this code will be the n+1-th 
	#Row in the Grid.
	
	var num_rows_to_add = DATA.get_answer_length() - 1
	
	for n in num_rows_to_add:
		var Row_scene = load("res://Scenes/Row.tscn")
		var scene_instance: Node = Row_scene.instance()
		scene_instance.name = "Row"+str(n+2)
		add_child(scene_instance)


func _input(event: InputEvent):
	
	#Sets row_node to currently active instance of Row
	var row_node: Node = get_node("Row" + str(current_row))
	
	#Triggers if word is correct - calls xxx in Row.gd
	if (event.as_text() == "Enter"
		and row_node.is_row_full() 
		and row_node.guessed_word == DATA.answer):
			row_node.compare_letters()
		
	#Triggers if word is incorrect.
	elif (event.as_text() == "Enter"
		and row_node.is_row_full() 
		and row_node.guessed_word != DATA.answer):
			
			#Assesses guess and colours accordingly
			row_node.compare_letters()
			
			var total_rows: int = DATA.get_answer_length()
			
			if current_row == total_rows:
				#Finish game - TODO
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
