
import UIKit

class DiffPrototypeCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel!
    private var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Addresses a separate issue and prevent auto layout warnings due to the temporary width constraint in the xib.
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Code below is needed to make the self-sizing cell work when building for iOS 12 from Xcode 10.0:
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
    }
    
    func configure(item: DiffItem, width: CGFloat) {
        widthConstraint.constant = width
        widthConstraint.isActive = true
        
        let insertedRanges = item.highlightRanges.filter { $0.type == .add }.map { NSRange(location: $0.start, length: $0.length) }
        let deletedRanges = item.highlightRanges.filter { $0.type == .delete }.map { NSRange(location: $0.start, length: $0.length) }
        
        var text: String;
        if item.text == "" && (item.highlightRanges.count == 1 && item.highlightRanges[0].start == 0 && item.highlightRanges[0].length == 1) {
            //annoying workaround for collapsing nonbreaking space from C++
            text = " "
        } else {
            text = item.text
            }
        setAttributedString(text: text, insertedRanges: insertedRanges, deletedRanges: deletedRanges)
    }
    
    private func setAttributedString(text: String, insertedRanges: [NSRange], deletedRanges: [NSRange]) {
        let attributedString = NSMutableAttributedString(string: text)
        
        for insertedRange in insertedRanges {
            attributedString.setAttributes([NSAttributedString.Key.backgroundColor: UIColor.green], range: insertedRange)
        }
        
        for deletedRange in deletedRanges {
            attributedString.setAttributes([NSAttributedString.Key.backgroundColor: UIColor.red], range: deletedRange)
        }
        
        textLabel.attributedText = attributedString.copy() as? NSAttributedString
    }
}
