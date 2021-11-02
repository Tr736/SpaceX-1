import Kingfisher
import UIKit
class ConcreteImageProvider: ImageProvider {
    func setImage(with url: URL, for imageView: UIImageView) {
        imageView.kf.setImage(with: url)
    }
}
