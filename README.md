# BruteForceRegistration
Image registration by selecting by hand  corresponding features locations in two images. This repository contains
a GUI function to select corresponding features in two images (**SelectFeatures.m**).
To see how it works run the script DEMO.m

![GIF](./figures/SelGIF.gif)

## Fit geometric transformation
the main algorithm in this function is the one that fits geometric transformation to control point pairs
([**fitgeotrans.m**](https://www.mathworks.com/help/images/ref/fitgeotrans.html))

The two imagesc should have the same resolution.


![selection](./figures/selection.png)


![selection](./figures/test.png)
