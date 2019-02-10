import UIKit
extension UIView {
    @objc public static var identifier: String = {
        return String(describing: self)
    }()
}
