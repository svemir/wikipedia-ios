
import UIKit

class DiffPrototypeSectionHeader: UICollectionReusableView {
    
    static let paddingLeft: CGFloat = 5
    static let paddingRight: CGFloat = 5
    static let paddingTop: CGFloat = 5
    static let paddingBottom: CGFloat = 5
    
    
    static var paddingHorizontal: CGFloat {
        return paddingLeft + paddingRight
    }
    
    static var paddingVertical: CGFloat {
        return paddingTop + paddingBottom
    }
    
    
    @IBOutlet var textLabel: UILabel!
    
    func configure(text: String) {
        textLabel.text = text
    }
}
