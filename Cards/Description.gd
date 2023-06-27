extends RichTextLabel

func _ready():
	self.bbcode_enabled = true
	
	# Store the current text in 'desc' variable
	var desc = self.bbcode_text

	# Clear the RichTextLabel
	self.clear()
	
	# Split the text into individual words
	var words = desc.split(" ")
	
	# Initialize an empty string for the new text
	var new_text = "[center]"

	# Process each word
	for word in words:
		var clean_word = word
		var suffix = ""
		if word.ends_with(",") or word.ends_with("."):
			suffix = word.right(word.length()-1)
			clean_word = word.left(word.length()-1)
		
		var last_char = clean_word.right(len(clean_word)-2)
		if clean_word.ends_with("+") or clean_word.ends_with("-"):
			# If the word ends with "+" or "-", color it accordingly and remove the symbol
			var modifier_type = clean_word.right(clean_word.length()-1)
			clean_word = clean_word.left(clean_word.length()-1)
			if clean_word.ends_with("%"):
				# If the word now ends with "%", color it
				if modifier_type == "+":
					new_text += "[color=#00FF00]" + clean_word + "[/color]" + suffix + " "
				else:
					new_text += "[color=#FF0000]" + clean_word + "[/color]" + suffix + " "
		else:
			new_text += clean_word + suffix + " "
	
	# Close the centering tag
	new_text += "[/center]"
	new_text = new_text.replacen(" 1", "       1")
	
	# Set the new text
	self.bbcode_text = new_text
