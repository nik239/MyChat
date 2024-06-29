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
**On Redux**
The project's main goal was to experiment with some architectural patterns. As a result, it turned out to be much more bloated with boilerplate than it needed to be. 
