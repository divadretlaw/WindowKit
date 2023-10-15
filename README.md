# WindowKit

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdivadretlaw%2FWindowSceneReader%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/divadretlaw/WindowKit)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdivadretlaw%2FWindowSceneReader%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/divadretlaw/WindowKit)

Handle `UIWindow` & `UIWindowScene` within SwifUI and present SwiftUI Views in their own window.

## Usage

### `windowCover(isPresented:content:)`

![Static Badge](https://img.shields.io/badge/Platform_Compability-iOS%20%7C%20visionOS%20%7C%20tvOS-orange?logo=swift&labelColor=white)

Present a modal view within it's own `UIWindow` from any SwiftUI view.

Usage is similar to `fullscreenCover(isPresented:content:)`

```swift
.windowCover(isPresented: $isPresented) {
    MyWindowCover()
}
```

You can also configure the window presentation

```swift
.windowCover(isPresented: $isPresented) {
    MyWindowCover()
} configure { configuration in
    // Customize the window cover presentation
} 
```

#### Environment

In order to dismiss the window cover, use the `dismissWindowCover` from the environment

```swift
@Environment(\.dismissWindowCover) var dismiss
```

In case the current view is not presented within a window cover the `dismissWindowCover` action will do nothing.


### [`WindowReader`](https://github.com/divadretlaw/WindowReader)

![Static Badge](https://img.shields.io/badge/Platform_Compability-iOS%20%7C%20macOS%20%7C%20visionOS%20%7C%20tvOS-orange?logo=swift&labelColor=white)

Read the current `UIWindow` or `NSWindow` with `WindowReader`

```swift
@main
struct MyView: View {
    var body: some Scene {
        WindowReader { window in
            ...
        }
    }
}
```

On child views the `UIWindow` or `NSWindow` will be available in the `Environment`

#### Environment

```swift
@Environment(\.window) var window
```

### [`WindowSceneReader`](https://github.com/divadretlaw/WindowSceneReader)

![Static Badge](https://img.shields.io/badge/Platform_Compability-iOS%20%7C%20visionOS%20%7C%20tvOS-orange?logo=swift&labelColor=white)
#### SwiftUI Lifecycle

Read the current `UIWindowScene` with `WindowSceneReader`

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            WindowSceneReader { windowScene in
                ContentView()
            }
        }
    }
}
```

alternatively, just add `windowScene()` if you only need the window scene on child views.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .windowScene()
        }
    }
}
```

On child views the `UIWindowScene` will be available in the `Environment`

#### UIKit Lifecycle

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let rootView = ContentView()
                .windowScene(windowScene)
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
    }
}
```

#### Environment

```swift
@Environment(\.windowScene) var windowScene
```

The `@Environment(\.windowScene) var windowScene` defaults to the first connected `UIWindowScene` or `nil` if no `UIWindowScene` is connected.

## License

See [LICENSE](LICENSE)
