// **INFO** //
// version: 09/2025
// loops through multi-series files in a directory and saves each serie as a separate tif file
// author: Ted Aplin

// Example annotation with persistence off
#@ String (value="This macro converts proprietary formats into TIFF files using the Bio-Formats Plugin", visibility="MESSAGE", required=false, persist=false) hint1
#@ String (value="Requires at least enough RAM to open one slice/frame", visibility="MESSAGE", required=false, persist=false) hint2
#@ String (value="Author Edward (Ted) Aplin", visibility="MESSAGE", required=false, persist=false) hint3

#@ File (label = "Select folder with raw data", style="directory") input //defines folder with raw data
#@ File (label = "Select folder to export files to", style="directory") output //defines output directory for exported data
#@ String (label="Image files extension:", choices={"all", ".lif", ".nd2", ".czi", ".vsi"}, style="radioButtonHorizontal") extension //defines extension of files to be processed



//cleanup
setBatchMode(true);
close("*");

//creates a list of only specific fileformat files

list = getFileList(input);
fileList = newArray(0);

// if all is selected then it lists all files with a relevant filetype from the folder
if (extension == "all") {
	for (l = 0; l < list.length; l++) {
	   	if (endsWith(list[l], ".lif") | endsWith(list[l], ".vsi") | endsWith(list[l], ".czi") | endsWith(list[l], ".nd2"))
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


//the macro
for (b = 0; b < fileList.length; b++) { // for each file in the list of relevant files
	
	// get their name and filepath
	name=fileList[b];
	fname_with_path = input + File.separator + fileList[b];
	
	// open the file with Bio-formats Importer, with virtual stack on to allow for greater file sizes on less powerful hardware
	// if there is an issue, you can turn virtual stack off
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

		//renaming title
		title = getTitle();
		if (seriesCount == 1) { // if only one file then change extension
			name = substring(title, 0 , title.length-4);
			saveName = name;
				
		}
		else { // if multiple files then number them accordingly
			saveName = title;
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
showMessage("'Export as TIFF' macro completed");