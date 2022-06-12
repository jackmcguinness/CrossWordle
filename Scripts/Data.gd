extends Node

var guess_n : int = 0 #gets incremented for each guess
var answer : String = ""

func _ready():
	#Set answer to random word - current manually set to length 5 but this will
	#change to variable for CrossGrid to call when implemented 
	answer = generate_answer_word(5)

	#Capitalises answer to match capitalised letter inputs
	answer = answer.to_upper()

	print(answer)

func get_answer_length():
	#answer.length() used a lot throughout different scripts, so getter written 
	#in case the variable name needs to change for some reason.
	return answer.length()


func generate_answer_word(length: int):
	#Read array of n letter words from Data file
	var word_array = read_word_file(length)
	
	#Set up random number
	var rng = RandomNumberGenerator.new() 
	rng.randomize()
	var random_i = rng.randi_range(0, word_array.size())
	
	#Get random word from array
	return word_array[random_i]


func read_word_file(length: int):
	#This is a bit of a janky solution and needs refactoring as it relies each 
	#n-letter word file existing, which we can't be sure of at the moment.
	#Ideally, the file processing tool needs refactoring to create one single 
	#json file containing all lengths of words, with each array of n-length words 
	#held in an object. 
	
	var file_name = str(length) + " Letter Dict.json"
	
	var word_array = []
	var file = File.new()
	file.open("res://Data/Word files/" + file_name, file.READ)
	var text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(text)
	word_array = data_parse.result
	
	return word_array
