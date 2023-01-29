# Test Flutter App - Google Maps

## Background

Challenge application built in a single continuous coding round. Shows pins on a Google Map based on search; details can then be expanded.

The app is built in Flutter and tested on Android. The Flutter codebase is in /mapapp


## Screenshots
Here are some screenshots of the app in action:

![base](https://raw.githubusercontent.com/talhajavedmukhtar/testMap/main/screenshots/screenshot2.jpeg)
![details](https://raw.githubusercontent.com/talhajavedmukhtar/testMap/main/screenshots/screenshot3.jpeg)

## Some Notes

 - The search in this basic version only works if the **exact queries** from the possible "place types" are entered.
	 - The list is present here <https://developers.google.com/maps/documentation/places/web-service/supported_types>
	 - [UX IMPROVEMENT] regex matching can be used in a next iteration to even further improve search by making it more flexible/dynamic. For example, allow hospitals to be a valid query instead of just hospital.
 - Apk is present in the /apks for a direct install.
 - Focus was on exploring efficient use of state for a good UX. UI was not focused on, as is obvious.
	 - [UX IMPROVEMENT] Marker color should be changed upon tap to emphasize which marker's details are currently being viewed.
