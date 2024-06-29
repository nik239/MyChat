# MyChat
**A messenger app built with SwiftUI and Firebase to explore Redux-like architecture.**

## Functionality
MyChat implements the basic functionality of a messenger, namely:
* Authentication (sign in with Apple or email and password)
* Creating a chat/a group chat
* Sending messages
* Receiving messages

## Key Features
* Native SwiftUI dependency injection
* MVVM with Redux-like centralized AppState for shared data
* Swift concurrency with some Combine elements (more on this below)
* Full test coverage (unit tests, mocking)
* UI tests with [ViewInspector](https://github.com/nalexn/ViewInspector)
* Programmatic navigation

## Architecture Overview
The project's architecture was inspired by [CountriesSwiftUI](https://github.com/nalexn/clean-architecture-swiftui/tree/master) and follows the pattern below.
<br>
<img width="889" alt="Screenshot_2024-04-11_at_16 03 06" src="https://github.com/nik239/MyChat/assets/116445208/7eb33648-1a3e-4d58-828b-23e86fc7e1fa">
<br>

## Key Takeaways
**On Architecture**
<br>
In attempting to experiment with architectural patterns the project turned out to be much more bloated with boilerplate than it needed to be. While the idea of a bootstrap() function as a centralized initialization point has an appeal in its potential for maintainability, scalability, and testability, I believe that for small and medium-sized projects, it's certainly overkill. Concerning the AppState object, I've found it quite handy for storing data that need to be shared/accessed across the app, including authentication data (uid, etc.) and view routing data. It lends itself well to serializing access to this data by using Swift's Actor model in combination with "private(set)" variables and dedicated setter functions. It can be a more structured alternative to singletons. At the same time, I think it's important to have restraint in choosing what to include in AppState as there's a risk of making it into a God object.
<br>
**On Actors**

