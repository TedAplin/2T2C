// **INFO** //
// version: 09/2025
// Applying auto brightness and contrast to all relevant files in a folder
// author: Edward (Ted) Aplin



//GUI asking for inputs
#@ String (value = "Auto brightness/ contrast all TIFF files in a directory", visibility="MESSAGE", required=false, persist=false) hint1 // adds text, can be used inbetween inputs too
#@ String (value = "Author: Edward (Ted) Aplin", visibility="MESSAGE", required=false, persist=false) hint2 // adds text, can be used inbetween inputs too

#@ File (label = "Select folder with raw data", style="directory") input //defines folder with raw data
#@ File (label = "Select folder to export files to", style="directory") output //defines output directory for exported data

#@ String (label="Auto mode:", choices={"Yes", "No"}, style="radioButtonHorizontal") Auto // switches between auto and manual
#@ String (value = "If Auto is off, define the minimum and maximum intensity", visibility="MESSAGE", required=false, persist=false) hint3 // adds text, can be used inbetween inputs too
#@ Integer (label="Minimum intensity") Min // Sets min intensity
#@ Integer (label="Maximum intensity") Max // Sets max intensity

//cleanup
setBatchMode(true);
close("*");

//creates a list of only specific fileformat files

list = getFileList(input);
fileList = newArray(0);

// if a specific extension is selected then only files with that extension are listed
for (l = 0; l < list.length; l++) {
   	if (endsWith(list[l], ".tif"))
   	fileList = Array.concat(fileList, list[l]);
}

// stopping if no relevant files
if (fileList.length == 0) {
	exit("no TIFF files in input directory");
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
	
	run("Brightness/Contrast...");
	// setting auto brightness and contrast
	if (Auto == "yes") {
		run("Enhance Contrast", "saturated=0.35");
	}
	// setting manual brightness and contrast
	else {
		setMinAndMax(Min, Max);
	}
	
		
	//renaming title
	title = getTitle();
	name = substring(title, 0 , title.length-4);
	saveName = name + "_BCadj";
	
	// saving the output as a Tiff
	saveAs("Tiff",  output + File.separator + saveName +".tif");
	
	// updating the User
	print("File Processed");
	// closing anything open
	close("*");
}

// telling the user it is complete
showMessage("'set Brightness and Contrast' macro completed");











