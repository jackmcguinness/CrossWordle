def main():
    word_length = get_desired_word_length()
    create_word_list(word_length)
    format_word_list_for_JSON(word_length)
    file_report(str(word_length))

def get_desired_word_length():
    print("\n\n")
    welcome_msg = "This tool will search a dictionary for words of a certain length, and create a JSON file, which holds an array containing these words.\n"
    welcome_msg = welcome_msg + "What length of word do you need?: "

    print(welcome_msg, end = ' ')

    length_input = input()

    return int(length_input)

def create_word_list(word_length: int):
    #This function creates a .txt file containing all n-length words
    #The .txt file is renamed to .json in the next function, but this function keeps
    # the .txt format for debugging and future use

    new_file_name = get_dict_file_name(str(word_length))

    #Source file is a list of 58110 words from the English dictionary
    source_file = get_filepath_to_word_files() + "Dictionary File/all word dictionary.txt"
    new_file    = get_filepath_to_main_dir() + "Tools/txt files/" + new_file_name + ".txt"

    with open(source_file, "r") as s:
        source_words = s.read().splitlines()

    with open(new_file, "x") as n:

        for word in source_words:

            if len(word) == word_length:
                n.write(word + "\n")


def format_word_list_for_JSON(word_length: int):
    # This function formats the list of words into a JSON array

    new_file_name = get_dict_file_name(str(word_length))
    txt_path  = get_filepath_to_main_dir() + "Tools/txt files/" + new_file_name + ".txt"
    json_path = get_filepath_to_word_files() + new_file_name + ".json"
    
    #Format file
    with open(txt_path, "r") as f: 
        lines = f.read().splitlines()

    with open(json_path, "x") as f:
        #For first line: open bracket 
        f.write("[" + "\n")

        #For each word line:
        #Add 2 spaces to start of line, "quotations" around the word, and append comma to end
        for line in lines:
            f.write("  " + '"' + line + '"' + "," + "\n")
        
        #For last line: close bracket
        f.write("]")

def file_report(word_length):

    number_words_found = str(get_number_words_found(word_length))

    print("New file '" + get_dict_file_name(word_length) + ".json' created in 'Data/Word' files directory.")
    print(number_words_found + " " + word_length + "-letter words found.")
    
    print("\n\n")


### Helper functions ###

def get_dict_file_name(word_length: str):
    name = word_length + " Letter Dict"
    return name

def get_filepath_to_main_dir():
    #Get current file path (where script is located)
    filepath = __file__
    filepath = filepath.replace("/file_processing_tool.py", "")

    #Move up to main 'CrossWordle' directory
    filepath = filepath.replace("Tools", "")

    return filepath

def get_filepath_to_word_files():
    filepath = get_filepath_to_main_dir() + "/Data/Word files/"
    return filepath

def get_number_words_found(word_length: str):
    filepath = get_filepath_to_main_dir() + "/Tools/txt files/" + get_dict_file_name(word_length) + ".txt"

    with open(filepath, "r") as f:
        lines = f.read().splitlines()

    num_words_found = len(lines)
    return num_words_found

if __name__ == "__main__":
    main()
