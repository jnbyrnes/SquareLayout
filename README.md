# Square Layout Problem

This app reads and parses the "square_hierarchy_structure.json" file and builds a corresponding square hierarchy layout

----------------

### Assumptions

* Made keywindow background color white
* Added AlertView with message is json file is missing or syntactically incorrect

----------------

### Considerations

* Look at main queue vs background queue processing
	* Right now there is no user action that would be blocking. If there is such action, could look to not only doing the json parsing on the background queue, but also the calculation of the view placements and sizes. These values could be added to properties on the square object. The only thing that would needed to be done on the UI view then is adding the subviews.
* Look at rotation
	* Tested rotation to all four orientations and they worked.
* Look at experience on ios 5/6/7
	* Tested functionality on ios5, 6 and 7 and they worked.
* Add unique id to square
	* Added unique identifier to square to allow for addition and removal of squares as a result of gesturerecognizers that would react to user interaction. Unique id is necessary to find the view that expeiences the tap and map to specific square, which then could be deleted or have subviews added to the object
* Unit Tests
	* Did not add unit tests as part of this project, but unit tests could be added to validate that a created square matches the json requirements, that the number of squares match, that the square has proper subview squares, etc.

----------------

### Tasks Undertaken

* Base Case
* Swiping to delete view and children
* Tapping on any view to randomly insert 1-3 children
* Long-pressing to be able to move view to different location in object hierarchy
