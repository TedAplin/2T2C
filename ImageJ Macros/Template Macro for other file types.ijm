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
#@ String (label="Image files extension:", choices={"all", ".tif", ".lif", ".nd2", ".czi", ".vsi"}, style="radioButtonHorizontal") extension //defines extension of files to be processed

// text entry
#@ String (label = "Enter text here") text // stores text

// number entry
#@ int number (label = "Enter number here") number // stores a number

//cleanup
setBatchMode(true);
close("*");

//creates a list of only specific fileformat files

list = getFileList(input);
fileList = newArray(0);

// if all is selected then it lists all files with a relevant filetype from the folder
if (extension == "all") {
	for (l = 0; l < list.length; l++) {
	   	if (endsWith(list[l], ".tif") | endsWith(list[l], ".lif") | endsWith(list[l], ".vsi") | endsWith(list[l], ".czi") | endsWith(list[l], ".nd2"))
	   	fileList = Array.concat(fileList, list[l]);
	}
}

// if a specific extension is selected then only files with that extension are listed
else {
	for (l = 0; l < list.length; l++) {
	   	if (endsWith(list[l], extension))
	   	fileList = Array.concat(fileList, list[l]);
	}
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
	run("Bio-Formats Macro Extensions");
	run("Bio-Formats Importer", "open=[" + fname_with_path + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1 use_virtual_stack");
	
	// getting the number of images in File
	seriesCount = 0;
	Ext.setId(fname_with_path)
	Ext.getSeriesCount(seriesCount);
	
	// updating user
	print("Analyzing Image " + name);
	close("*");
	
	//processing each image
	for (i = 1; i <= seriesCount; i++) { //seperating out if file contains multiple images
		
		// opening each series
		run("Bio-Formats Importer", "open=[" + fname_with_path + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_"+i+" use_virtual_stack");
		
		
		
		// PLACE YOUR INSTRUCTIONS FOR EACH IMAGE HERE
		
		
		
		//renaming title
		title = getTitle();
		name = substring(title, 0 , title.length-4);
		saveName = name + "_ADDITION TO NAME";
		if (seriesCount > 1) { // adds a number to distinguish between multiple images in the same file
			saveName = saveName + "_" + i;		
		}
		
		// saving the output as a Tiff
		saveAs("Tiff",  output + File.separator + saveName +".tif");
		
		// updating the User
		print(i+" of " + seriesCount + " series processed.");
	}
	
	// closing anything open
	close("*");
}

// telling the user it is complete
showMessage("macro completed");