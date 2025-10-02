// **INFO** //
// version: 09/2025
// Template Macro for completing tasks on all relevant files in a folder
// author: Edward (Ted) Aplin



//GUI asking for inputs
#@ String (value = "Explanation for Macro", visibility="MESSAGE", required=false, persist=false) hint1 // adds text, can be used inbetween inputs too
#@ String (value = "Author: YOUR NAME, based off work by: Edward (Ted) Aplin", visibility="MESSAGE", required=false, persist=false) hint2 // adds text, can be used inbetween inputs too

#@ File (label = "Select folder with raw data", style="directory") input //defines folder with raw data
#@ File (label = "Select folder to export files to", style="directory") output //defines output directory for exported data

// multiple choice entry
#@ String (label="make a decision:", choices={"first", "second", "third", "and so on..."}, style="radioButtonHorizontal") extension //defines extension of files to be processed

// text entry
#@ String (label = "Enter text here") text // stores text

// number entry
#@ Integer (label = "Enter number here") number // stores a number

//cleanup
setBatchMode(true);
close("*");

//creates a list of only specific fileformat files

list = getFileList(input);
fileList = newArray(0);

// if all is selected then it lists all files with a relevant filetype from the folder
for (l = 0; l < list.length; l++) {
   	if (endsWith(list[l], ".tif"))
   	fileList = Array.concat(fileList, list[l]);
}

// stopping if no relevant files
if (fileList.length == 0) {
	exit("no relevant files in input directory");
}

//the macro
for (b = 0; b < fileList.length; b++) { // for each file in the list of relevant files
	
	// get their name and filepath
	name=fileList[b];
	fname_with_path = input + File.separator + fileList[b];
	
	// open the file with Bio-formats Importer, with virtual stack on to allow for greater file sizes on less powerful hardware
	// if there is an issue, you can turn virtual stack off by reming "use_virtual_stack" from the end of the string below
	run("TIFF Virtual Stack...", "open=[" + fname_with_path + "]");
	print("Analyzing Image " + name);// notifying user
	
	
	
	// Place your instructions in here
	

		
	//renaming title
	title = getTitle();
	name = substring(title, 0 , title.length-4);
	saveName = name + "_ADDITION TO NAME";
	
	// saving the output as a Tiff
	saveAs("Tiff",  output + File.separator + saveName +".tif");
	
	// updating the User
	print("File processed.");
	// closing anything open
	close("*");
}

// telling the user it is complete
showMessage("macro completed");