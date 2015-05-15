/*
* ImageJ / Fiji -  Macro template to Join multiple pair images in a folder
* Author: Job Diogenes Ribeiro Borges
* Email: job at nupelia.uem.br
* Licence: GNU AFERO    GNU AFFERO GENERAL PUBLIC LICENSE
*
*/

inputDir = getDirectory("Input directory");
outputDir = getDirectory("Output directory");
overwrite = false

Dialog.create("Stitching all Pair (a,b) Files");
Dialog.addString("Files to proccess?", ".jpg", 5);
Dialog.addMessage("Ex: img001a.jpg + img001b.jpg = img001.jpg");
Dialog.addMessage("Ex: img001a.tif + img001b.tif = img001.tif");

suffix = Dialog.getString();
a_suffix = "a"+suffix;
b_suffix = "b"+suffix;

if (inputDir == outputDir) {
	Dialog.addCheckbox("Overwrite? ", false);
    overwrite = Dialog.getCheckbox();
}	
Dialog.show();

processFolder();

function stitchFile(firstimage, secondimage, saveto) {
    setBatchMode(true);
	print("Processing Images Pairs: " + firstimage +" - "+secondimage);
	open(inputDir+firstimage);
	open(inputDir+secondimage);
	run("Pairwise stitching", "first_image="+firstimage+" second_image="+secondimage+" fusion_method=[Linear Blending] fused_image=0300.jpg check_peaks=5 compute_overlap x=-2.0000 y=-738.0000 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");
    saveAs("Jpeg", outputDir+saveto);
    close();
	close();
	close();	
	setBatchMode(false);
}

function processFolder() {
	list = getFileList(inputDir);
	for (i = 0; i < list.length; i++) {
		if (!File.isDirectory(list[i])) {
			showProgress(i, list.length);
			if(endsWith(list[i], a_suffix)) {
				cFile = substring( list[i], 0, ( lengthOf(list[i])-lengthOf(a_suffix) ))+suffix;
				bFile = substring( list[i], 0, ( lengthOf(list[i])-lengthOf(a_suffix) ))+b_suffix;
				aFile = list[i];
				if (File.exists(inputDir+bFile)) {
				    if (!File.exists(outputDir+cFile)) 
							stitchFile(aFile, bFile, cFile);					 
				    else if (overwrite)
							stitchFile(aFile, bFile, cFile);					 
				}			
			}
		}
	}
}
