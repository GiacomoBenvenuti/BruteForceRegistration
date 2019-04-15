### :octopus: [giacomox - Home](https://giacomox.github.io/#/RetinoProj/README) :octopus:

# Brute Force Registration
Image registration by selecting by hand corresponding features locations in two images. This repository contains
a GUI function to select corresponding features in two images (**SelectFeatures.m**).
To see how it works run the script DEMO.m

<img src="./figures/SelGIF.gif" width="80%" align="center">


## Fit geometric transformation
* The main algorithm in this function is the one that fits geometric transformation to control point pairs
([**fitgeotrans.m**](https://www.mathworks.com/help/images/ref/fitgeotrans.html))

* The two images should have the same resolution.

* Try to select 2D features like corners, in different positions of the image.

<img src="./figures/selection.png" width="100%" align="center" margin-left= auto>

*
<img src="./figures/test.png" width="50%" align="center">
