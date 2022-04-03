# Games App 

**Games App** is an application that interacts with [rawg.io](https://rawg.io/apidocs) video games API and helps the user to search and save his favorite games.

## How to run the project

```Clone``` and run! no dependencies required for now. 

Add your API key to API_KEY in GamesApp/Shared/Enviroment/.XCConfig (Make sure to include the key for the choosen build scheme config file) 

## Project Overview

User can search for a game and gets information like the Metascore rating, the genre, and a description. Also, the user can save a game to store locally on his device. 

## App Features

**Games:** the main screen and here the user can search and find games from rawg.io API. 

**Details:** a more informative screen for the selected game, including description and hyperlinks for the Reddit community and website for the selected game. On this screen, users can save games locally.

**Favorites:** contains pre-saved games on the details screen. 

## Project Architecture

The project is following **clean architecture** and uses **MVVM** with a group of practices and decisions that makes the code testable with dependable components.

Every module consists of the **Presentation layer**, **Domain layer**, and **Data layer** for a better separation of concerns and single responsibility.

The view is **state-driven**. The view model controls the view's current state totally depending on the delegate pattern. 

## Enviroments:

Project supports three enviroments: **Development**, **Stage** and **Production**. The configurations is imported from .xcconfig file for each scheme.

## More info

The project depends on **URLSession** for networking and the network layer is built following **builder pattern**. 
Data is saved locally using **Coredata**.

## Things to improve 

The UI adaptivity with more screen sizes and landscape better support. 

## Issues to be solved 

Caching is not working as expecting. 

## Work in progress

README will be edited with more info. 

Log errors and decode which logging techniques to follow. 

Support pagination in games screen. 

Add swipe to delete to favorites screen, considering removing correctly from core data store. 

Support reachability detection and retry for networking. 

Add a read more button for the description label in the details screen. 

Write unit testing.

## Screenshots

![Simulator Screen Shot - iPhone 13 Pro Max - 2022-04-03 at 01 48 39](https://user-images.githubusercontent.com/69410556/161405498-2547da21-41a2-4694-9d02-5c58f8723703.png)
![Simulator Screen Shot - iPhone 13 Pro Max - 2022-04-03 at 01 48 44](https://user-images.githubusercontent.com/69410556/161405503-1cd27c9c-2619-46d3-98c6-ab0a0787a3ca.png)
![Simulator Screen Shot - iPhone 13 Pro Max - 2022-04-03 at 01 49 32](https://user-images.githubusercontent.com/69410556/161405509-3ca78fcf-e660-46da-89c3-1c23d8ebdce8.png)
![Simulator Screen Shot - iPhone 13 Pro Max - 2022-04-03 at 01 49 37](https://user-images.githubusercontent.com/69410556/161405511-690be19d-deb6-4b66-9080-1ddc8ae486ad.png)


