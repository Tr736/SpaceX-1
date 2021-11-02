import UIKit
/// Coordinator should be used to manage the screen transitions. You should NOT use Presentation methods directly in a ViewController or anywhere else.
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
