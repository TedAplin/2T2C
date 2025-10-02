// **INFO** //
// version: 09/2025
// Combines channels for all TIFF files in a folder
// author: Edward (Ted) Aplin



//GUI asking for inputs
#@ String (value = "merges channels for all TIFF files in a folder", visibility="MESSAGE", required=false, persist=false) hint1 // adds text, can be used inbetween inputs too
#@ String (value = "Author: Edward (Ted) Aplin", visibility="MESSAGE", required=false, persist=false) hint2 // adds text, can be used inbetween inputs too

#@ File (label = "Select folder with raw data", style="directory") input //defines folder with raw data
#@ File (label = "Select folder to export files to", style="directory") output //defines output directory for exported data

#@ String(value = "Enter which channel you want to be used for each colour (enter 0 if you don't want that colour)", visibility="MESSAGE") hint;
#@ Integer (label = "red:") C1
#@ Integer (label = "green:") C2
#@ Integer (label = "blue:") C3
#@ Integer (label = "grey:") C4
#@ Integer (label = "cyan:") C5
#@ Integer (label = "magenta:") C6
#@ Integer (label = "yellow:") C7

Channel = newArray(C1, C2, C3, C4, C5, C6, C7);
Error = 0;

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
	
	
	
	getDimensions(width, height, channels, slices, frames);
	
	if (channels == 1) {
		print(" ERROR:  only single channel image, not processed");
		Error = 1;
	}
	else{
		run("Split Channels");
		Command = "";
		Count = 0;
		//renaming
		for (i = 0; i < 7; i++) {
			if (Channel[i] != 0){
				if (Channel[i] > channels){
					print(" ERROR:  Channel " + Channel[i] + "out of range, only " + channels + "channels in original file");
					Error = 1;
				}
				else{
					Temp = "c" + i + "=[C" + Channel[i] + "-" + name + "] ";
					Command = Command + Temp;
					Count = Count + 1;
				}
			}
		}
		if (Command == "") {
			print(" ERROR:  No correct channels given, channels not merged");
			Error = 1;
		}
		else {
			run("Merge Channels...", Command + "create");
			saveName = substring(name, 0 , name.length-4) + "_Merge";
			saveAs("Tiff",  output + File.separator + saveName +".tif");
			// updating the User
			print(Count + " Channels successfully Merged");
		}
	}

	// closing anything open
	close("*");
}

// telling the user it is complete
if (Error == 1){
	showMessage("There is an issue with at least 1 process, check the log");
}
else {
	showMessage("All successful!");
}