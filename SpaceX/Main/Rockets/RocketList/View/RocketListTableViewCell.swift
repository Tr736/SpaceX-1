import UIKit
import Kingfisher

final class RocketListTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = String(describing: RocketListTableViewCell.self)

    private enum Constants {
        static let hPadding: CGFloat = 16.0
        static let vPadding: CGFloat = 8.0
    }

    private enum AccessibilityIdentifiers {
        static let titleLabel = "title_label"
        static let cell = "RocketList_cell"
        static let imageView = "image_view"
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = AccessibilityIdentifiers.titleLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var rocketImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.accessibilityLabel = AccessibilityIdentifiers.imageView
        return view
    }()

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }

    // MARK: - Prepare Views
    private func prepareView() {
        accessibilityLabel = AccessibilityIdentifiers.cell
        selectionStyle = .none
        prepareImageView()

        // TODO: Make cell look pretty :D
    }

    private func prepareTitleLabel() {
        guard titleLabel.superview == nil else { return }
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Constants.hPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: Constants.vPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -Constants.hPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -Constants.vPadding)
        ])
    }

    private func prepareImageView() {
        guard rocketImageView.superview == nil else { return }
        contentView.addSubview(rocketImageView)
        let heightConstraint = rocketImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            rocketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rocketImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rocketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rocketImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heightConstraint,
            rocketImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    // MARK: - Configure Cell
    func config(item: RocketListData,
                imageProvider: ImageProvider) {
        self.titleLabel.text = item.title
        if let imageURL = item.images.first {
            imageProvider.setImage(with: imageURL,
                                   for: rocketImageView)
        }
    }
}

