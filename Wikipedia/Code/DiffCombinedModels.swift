struct DiffResponse: Codable {
    let diffs: [DiffItem]
}

enum DiffItemType: String, Codable {
    case context
    case change
    case delete
    case add
}

enum DiffHighlightRangeType: String, Codable {
    case delete
    case add
}

struct DiffHighlightRange: Codable {
    let start: Int
    let length: Int
    let type: DiffHighlightRangeType
}

struct DiffItem: Codable {
    let type: DiffItemType
    let text: String
    let highlightRanges: [DiffHighlightRange]
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case highlightRanges = "highlight-ranges"
    }
}
//
//class DiffItemViewModel {
//    
//    let items: [DiffItemViewModel]
//    let modelGroup: DiffGroup
//    private(set) var sectionTextHeight: CGFloat = 0
//    var sectionText: String {
//        let lineNumberFormat = WMFLocalizedString("diff-section-header-line-number", value: "Line: %1$d", comment: "Text that displays as  Parameters:\n* %1$d - article title the current search result redirected from")
//        return NSString.localizedStringWithFormat(lineNumberFormat as NSString, modelGroup.lineToStart) as String
//    }
//    
//    init(modelGroup: DiffGroup, availableWidth: CGFloat) {
//        self.modelGroup = modelGroup
//        
//        var items = [DiffItemViewModel]()
//        for modelItem in modelGroup.items {
//            items.append(DiffItemViewModel(modelItem: modelItem))
//        }
//        
//        self.items = items
//        
//        calculateSectionTextHeight(availableWidth: availableWidth)
//    }
//    
//    func calculateSectionTextHeight(availableWidth: CGFloat) {
//        let boundingRect = (sectionText as NSString).boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)], context: nil)
//        sectionTextHeight = boundingRect.height
//    }
//}
//
//class DiffItemViewModel {
//    
//    let modelItem: DiffItem
//    
//    var text: String {
//        return modelItem.text
//    }
//    
//    init(modelItem: DiffItem) {
//        self.modelItem = modelItem
//    }
//}
