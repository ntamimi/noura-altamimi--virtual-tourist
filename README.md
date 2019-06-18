# noura-altamimi--virtual-tourist

## Introduction
virtual tourist projet it is an app that downloads and stores images from Flickr.

## Implementation
the app has tow main viewController 
- mapVC : to control the map view ( creating pin and get the coordenation and save in the core data )
- photoVC : to control the photos view ( how the collection of image like to be , bring the related picture to the selected pin , save and delete the photo from the core data and sharing the Link ) 

## how to build 
the project build with using multible Xcode Feature like using : 
- collection view to preview the flicker images 
- using to type of controller ( navigation : to navigate between the pages , viewControler : to controle single page ) 
- core data to save the required information 
- using NSFetchedResultsController to deal with the coredata 

## Requirements
* Xcode 12.2
* Swift 5

## Installation instructions
* Clone this repository at: ```git clone https://github.com/ntamimi/noura-altamimi--virtual-tourist```

## Features
The app will allow users to drop pins on a map, as if they were stops on a tour.
Users will then be able to download pictures for the location and persist both the pictures,
and the association of the pictures with the pin. the app provide to main function when clicking on the images
- delete the image 
- share the image link to different app 
finally you can load new collection of images by clicking on the specific button.
