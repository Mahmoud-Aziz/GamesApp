# Games App 

**Games App** is an application that interacts with rawg.io video games API and helps the user to search and save his favorite games.

## How to run the project

```Clone``` and run! no dependencies required for now. 

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

## More info

The project depends on **URLSession** for networking and the network layer is built following **builder pattern**. 
Data is saved locally using **Coredata**.


## Work in progress

README will be edited with more info. 

Add screen shots for the running application.

Support pagination in games screen. 

Add swipe to delete to favorites screen, considering removing correctly from core data store. 

Support reachability detection and retry for networking. 

Add a read more button for the description label in the details screen. 

## Screenshots
