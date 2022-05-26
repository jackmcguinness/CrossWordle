extends Node

var guess_n : int = 0 #gets incremented for each guess
var answer : String = ""

func _ready():
	#Set answer to random word.
	#(Currently sets to 5-letter word -- this needs rewriting to be scalable)
	
	answer = generate_answer()
	
	#Capitalises answer to match capitalised letter inputs.
	answer = answer.to_upper()
	
	print(answer)

func get_answer_length():
	#answer.length() used a lot throughout different scripts, so getter written 
	#in case the variable name needs to change for some reason.
	return answer.length()


func generate_answer():
	#Read array of n letter words from Data file
	var word_array = read_word_file()
	
	#Set up random number
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_i = rng.randf_range(0, word_array.size())
	
	#Get random word from array
	return word_array[random_i]


func read_word_file():
	#Currently reads 5 letter word
	#Needs scaling to read from various 'n letter dict' files depending on
	# required n value
	
	#word_array IS NOT BEING POPULATED IN HERE
	
	var word_array = []
	var file = File.new()
	file.open("res://Data/Word files/5 Letter Dict.json", file.READ)
	var text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(text)
	word_array = data_parse.result
	
	return word_array
