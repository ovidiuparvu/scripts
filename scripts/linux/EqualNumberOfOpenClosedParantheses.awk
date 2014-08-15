# This pattern matches all lines
/.*/ { 
	# Count the number of left parantheses
	nrOfLeftParantheses = gsub("[(]", "("); 
	
	# Count the number of right parantheses
	nrOfRightParantheses = gsub("[)]", ")"); 

	if (nrOfLeftParantheses != nrOfRightParantheses) { 
		print(NR " " $0); 
	}
}
