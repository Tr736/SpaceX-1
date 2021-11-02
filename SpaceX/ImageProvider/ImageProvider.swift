import UIKit
/// ImageProvider enables you to inject dependcy code from a third party frame work like KF or SDWebImage into the imageview.
/// We do not want cells etc to depend on the framework directly. Especially if we plan on modulising the app in the near future
public protocol ImageProvider {
    func setImage(with url: URL, for imageView: UIImageView)
}
