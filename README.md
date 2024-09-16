## Memo

### Difference between singleton manager vs dependency manager. Can you explain differences?

Singleton Manager example:
```swift
class SingletonManager {
       var environment: EnviromentManager {
                get {
                  // singleton implementation
             }
        }
}
```


While its true that a singleton manager may look similar to a dependency container, there are some major differences, that are vital to the scalability of a project, when modularised.
As shown in this example above, we could have a SingletonManager and add variables for each of our dependencies. Then later on we could just access them. 
But the problem with this approach is, now SingletonManager needs to know about all our dependencies. Their interfaces (protocols) and the actual implementations. This makes the manager a heavy package, if it was to be moved to its own package. Which prevents us from having a lightweight dependency manager. Since it has to know the details of all other packages, it has to import them all, and then when we need to import the manager our modules, they will also be indirectly importing all these packages, and will take longer to build each module package, as if we didn't modularise them.

But the DependencyContainer we build here has no idea about the dependencies, their interfaces or implementation details. It is a very lightweight container with no package dependencies. So all our module packages can easily import it and interact with it. The container only knows about foundational types of ObjectIdentifier, Any and AnyObject.

Additionally, with a singleton manager that exposes everything, any module accessing it will have access to all dependencies, even the ones it doesn't need. But with dependency container's we can have a better control. Because the module can only access to a dependency that it knows about, via its interface protocol.

My research:
| Aspect              | Singleton Manager                         | Coordinator                                              |
|---------------------|-------------------------------------------|----------------------------------------------------------|
| Coupling            | Tight coupling to global state            | Loose coupling, modularized by feature                    |
| State Management    | Global, shared state across the app        | Localized, scoped to specific flows/features              |
| Dependency Handling | Centralized, harder to replace for testing | Localized, easy to mock or replace                        |
| Navigation          | Not suitable for managing navigation flows | Handles view creation and navigation easily               |
| Testability         | Harder to test in isolation                | Easier to test navigation and logic                       |
| Flexibility         | Less flexible, requires changes in many places | High flexibility and scalability                       |

### Singleton Manager 

```swift
final class SingletonManager {
    static let shared = SingletonManager()
    
    // Global services
    let homeService: HomeService
    let analyticsTracker: AnalyticsEventTracker

    private init() {
        self.homeService = HomeService() // Singleton holds direct reference
        self.analyticsTracker = AnalyticsEventTracker.shared
    }

    // Accessing shared instance
    func getHomeService() -> HomeService {
        return homeService
    }

    func getAnalyticsTracker() -> AnalyticsEventTracker {
        return analyticsTracker
    }
}

class HomeViewController: UIViewController {
    let homeService = SingletonManager.shared.getHomeService()
    let analyticsTracker = SingletonManager.shared.getAnalyticsTracker()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use services directly
        homeService.fetchHomeData()
        analyticsTracker.trackEvent("HomeViewOpened")
    }
}
```

## Coordinator Pattern
```swift
final class HomeCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Setup Home View with a ViewModel and push it to the Navigation stack
        let viewModel = HomeViewModel(homeService: HomeService(), analyticsTracker: AnalyticsEventTracker.shared)
        let homeView = HomeView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingVC], animated: false)
    }

    func pushSongDetail(_ song: Song) {
        let coordinator = SongDetailsCoordinator(navigationController: navigationController)
        let songDetailVC = coordinator.makeViewController(with: song)
        navigationController.pushViewController(songDetailVC, animated: true)
    }
}

final class RootCoordinator {
    private let navigationController = UINavigationController()

    func start() -> UIViewController {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        return tabBarController
    }
}
```

## Why Use the Coordinator Pattern?
Understanding the benefits of the Coordinator pattern can be challenging, especially when comparing it to a Singleton in simple cases. Singleton works well for small-scale apps, but as your app grows in complexity, the advantages of using the Coordinator pattern become clearer. Below are some of the key benefits of adopting the Coordinator pattern.

### 1. Separation of Navigation Logic
In a Singleton setup, UIViewController often handles its own navigation logic, but with the Coordinator pattern, all navigation responsibilities are delegated to a dedicated object. This means that each UIViewController can focus solely on its own presentation and data logic, while the Coordinator handles transitions, resulting in simpler and more understandable code.

Example:
Singleton: Each screen handles pushViewController or present.
Coordinator: The Coordinator manages all transitions, so views don’t need to know about navigation details.

### 2. Improved Testability
By isolating navigation logic within the Coordinator, it becomes much easier to test individual view controllers. If navigation is tightly coupled with the view controller, testing becomes cumbersome. Coordinators allow you to test views independently from navigation logic, making your codebase more maintainable and testable.

- Example:
  - Singleton: Navigation logic is embedded within the UIViewController, making navigation tests more difficult.
-  Coordinator: Since navigation is handled externally, view logic can be tested in isolation.

### 3. Reusability of Modules
Coordinators are created per screen or feature flow, making it easy to reuse specific screens or features in other projects. With Singleton, global services and state management can make it difficult to separate and reuse modules because of their tightly coupled dependencies.

- Example:
  - Singleton: Views are tightly bound to global state, making reuse difficult.
  - Coordinator: Each screen or flow is self-contained and easy to repurpose in other apps or modules.

### 4. Flexible Dependency Injection
Coordinators allow dependencies to be injected into each screen or feature, making it easy to swap out services, especially for testing. In contrast, Singleton enforces shared instances of services across the app, making it harder to replace them with mock objects during testing.

- Example:
  - Singleton: All screens use the same global service instance.
  - Coordinator: Different dependencies can be injected per screen, allowing flexible testing with mocks.

### 5. Clearer Responsibility
With Coordinators, each view controller is only responsible for its own UI and user interaction, while navigation and flow management are handled by the Coordinator. This results in cleaner, more maintainable code where responsibilities are clearly separated.

- Example:
  - Singleton: View controllers manage both UI logic and navigation, leading to overburdened components.
  - Coordinator: View controllers handle only UI, while Coordinators manage navigation and feature flows.

### 6. Scalability of Flows
Coordinators are ideal for managing complex flows, such as user authentication or purchase flows, where multiple screens need to work together in a cohesive manner. It’s easier to add new screens or modify flow behavior without affecting the rest of the app.

Example:
Singleton: Adding new flows might require modifying existing code, risking regressions.
Coordinator: New flows can be added with minimal impact on other parts of the app, promoting scalability.

### Summary
While Singleton may be sufficient for small apps, as your app grows, Coordinators provide significant advantages in managing dependencies, separating navigation logic, improving testability, and increasing scalability. The Coordinator pattern promotes cleaner, more modular, and maintainable code, making it an excellent choice for large-scale, complex apps.

