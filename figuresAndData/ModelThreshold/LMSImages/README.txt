The LMS image data is given in the folder LMSImages.
The LMSImages folder contains the LMS images for the 1100 images in each covariance dataset.
The data is stored in .mat file. 
The name of the file gives the covarianc scalar used to generate the 
reflectance spectra of the background objects.

The .mat files have an array of size 7803 x 1100. 
Each column contains one image. Each image was a 51x51x3 matrix
that was reshaped to get the 7803 long vector.

The columns are arranged in order of the LRFs of the target object. 
The first 100 images are for target object LRF at 0.35, the second 100 
images are for target object LRF at 0.36, and so on.