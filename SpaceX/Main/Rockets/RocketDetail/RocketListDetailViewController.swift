import UIKit
class RocketListDetailViewModel {
    // TODO: Build and Move
}

class RocketListDetailViewController: UIViewController {
    private let viewModel: RocketListDetailViewModel?

    init(viewModel: RocketListDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        viewModel = nil
        super.init(coder: coder)
        assertionFailure("RocketListDetailViewController dosnt use storyboards")
    }
}
