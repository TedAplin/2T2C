// **INFO** //
// version: 09/2025
// Compresses all files in a folder using 2d or 3d pixel binning
// author: Edward (Ted) Aplin



//GUI asking for inputs
#@ String (value = "Compresses all files in a folder using 2d or 3d pixel binning", visibility="MESSAGE", required=false, persist=false) hint1 // adds text, can be used inbetween inputs too
#@ String (value = "Author: Edward (Ted) Aplin", visibility="MESSAGE", required=false, persist=false) hint2 // adds text, can be used inbetween inputs too

#@ File (label = "Select folder with raw data", style="directory") input //defines folder with raw data
#@ File (label = "Select folder to export files to", style="directory") output //defines output directory for exported data

#@ String (value = "Auto mode, adjusts X and Y automatically to reduce file sizes to below 4gb (doesn't change Z)", visibility="MESSAGE", required=false, persist=false) hint3 // adds text, can be used inbetween inputs too
#@ string (label="Auto mode", choices={"yes", "no"}, style="radioButtonHorizontal") Mode
#@ String (value = "If Auto mode is set to no, then set manual values for compression", visibility="MESSAGE", required=false, persist=false) hint4 // adds text, can be used inbetween inputs too
#@ Integer (label="X and Y compression") XYScale
#@ Integer (label="Z compression ") ZScale

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

if (Mode == "yes") {
	for (b = 0; b < fileList.length; b++) {
		name=fileList[b];
		fname_with_path = input + File.separator + fileList[b];
		run("TIFF Virtual Stack...", "open=[" + fname_with_path + "]");
		print("Analyzing Image " + name);// notifying user
		FileSize = File.length(fname_with_path);
		
		if (FileSize > 3950000000) {
			if (FileSize > 15900000000) {
				run("Bin...", "x=3 y=3 z=1 bin=Average");
			}
			else {
				run("Bin...", "x=2 y=2 z=1 bin=Average");
			}
		}
		title = getTitle();
		name = substring(title, 0 , title.length-3);
		saveName = name + "_" + "Under4GB";
		saveAs("Tiff",  output + File.separator + saveName +".tif");
		close("*");
	}
}

else {
	for (b = 0; b < fileList.length; b++) {
		name=fileList[b];
		fname_with_path = input + File.separator + fileList[b];
		open(fname_with_path);
		print("Analyzing Image " + name);
		
		run("Bin...", "x=" + XYScale + " y=" + XYScale + " z=" + ZScale + " bin=Average");
		
		title = getTitle();
		name = substring(title, 0 , title.length-3);
		saveName = name + "_" + "Compressed";
		saveAs("Tiff",  output + File.separator + saveName +".tif");
		close("*");
	}
}


// telling the user it is complete
showMessage("'Compress Files' macro completed");










