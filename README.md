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
* Swift concurrency with some Combine elements (more on this in **Key Takeaways**)
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
In attempting to experiment with architecture the project turned out to be much more bloated with boilerplate than it needed to be. While the idea of a bootstrap() function as a centralized initialization point has an appeal in its potential for maintainability, scalability, and testability, I believe that for small and medium-sized projects, it's certainly overkill. Concerning the AppState object, I've found it quite handy for storing data that need to be shared/accessed across the app, including authentication data (uid, etc.) and view routing data. It lends itself well to serializing access to this data by using Swift's Actor model in combination with "private(set)" variables and dedicated setter functions. It can be a more structured alternative to singletons. At the same time, I think it's important to have restraint in choosing what to include in AppState as there's a risk of creating a God object.
<br>
<br>
**On Swift Actors**
<br>
As I introduced Swift concurrency to the Redux architecture, one interesting question that came up was whether to make AppState its own actor or add it to the main actor. One quirk of Swift's actor implementation is that while actor hopping is generally fast (as actors only guarantee that they run one method at a time, but not which thread they are running on), hopping to/from the main actor requires a context switch incurring a performance penalty ([WWDC Notes](https://wwdcnotes.com/notes/wwdc21/10134)). This creates a trade-off between the cost of performing work on the main thread and the cost of context switching.
<br>
<br>
**On Swift Concurrency and Combine**
<br>
In retrospect, this should have been obvious, but yeah they don't gel together. My initial thinking was, that it might slide, as long as Combine is used exclusively to propagate data along the main thread (from AppState to view model to view). I was able to get away with it, with some compiler warnings, however, the whole thing was ill-conceived. The problem is that Combine uses dynamic thread switching, which doesn't satisfy the compile-time guarantees of Swift's concurrency model. At best, this leads to erratic compiler warnings. I've posted about this here [@MainActor + Combine inconsistent compiler error](https://stackoverflow.com/questions/78245151/mainactor-combine-inconsistent-compiler-error).


