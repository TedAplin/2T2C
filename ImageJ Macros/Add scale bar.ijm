// **INFO** //
// version: 09/2025
// loops through files in a directory and creates a scale bar
// author: Edward (Ted) Aplin



//GUI asking for inputs
#@ String (value = "Add scale bar in batch", visibility="MESSAGE", required=false, persist=false) hint1 // adds text, can be used inbetween inputs too
#@ String (value = "Author: Edward (Ted) Aplin", visibility="MESSAGE", required=false, persist=false) hint2 // adds text, can be used inbetween inputs too

#@ File (label = "Select folder with raw data", style="directory") input //defines folder with raw data
#@ File (label = "Select folder to export files to", style="directory") output //defines output directory for exported data

#@ String (value = "adjust parameters of the scale bar, units are based on the units in the images metadata", visibility="MESSAGE", required=false, persist=false) hint3
#@ Integer (label = "Size of scale bar") Scale //defines size
#@ string (label = "Direction", choices={"horizontal", "vertical"}, style="radioButtonHorizontal") Direction //defines direction
#@ string (label = "Colour", choices={"White","Black","Light Gray","Gray","Dark Gray","Red","Green","Blue","Yellow"}, style="listBox") Colour //sets text colour
#@ string (label = "Background", choices={"None","White","Black","Light Gray","Gray","Dark Gray","Red","Green","Blue","Yellow"}, style="listBox") Background //sets background colour
 

//cleanup
setBatchMode(true);
close("*");

//creates a list of all tif files in directory
list = getFileList(input);
fileList = newArray(0);
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
	
	// open the file with virtual stack  to allow for greater file sizes on less powerful hardware
	run("TIFF Virtual Stack...", "open=[" + fname_with_path + "]");
	print("Analyzing Image " + name); // notifying user
	
	// add the scale bar
	run("Scale Bar...", "width=" + Scale + " height=" + Scale + " color=[" + Colour + "] background=[" + Background + "] " + Direction + " bold overlay");
		
	// renaming title
	title = getTitle();
	name = substring(title, 0 , title.length-4);
	saveName = name + "_ScaleBar";

	// saving the output as a Tiff
	saveAs("Tiff",  output + File.separator + saveName +".tif");
	
	// updating the User
	print("Image processed.");
	
	// closing anything open
	close("*");
}


// telling the user it is complete
showMessage("'add scale bar' macro completed");