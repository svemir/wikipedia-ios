

import UIKit

class DiffPrototypeViewController: UIViewController {

    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionView: UICollectionView!
    private let cellReuseIdentifier = "itemCell"
    private let sectionHeaderReuseIdentifier = "sectionHeaderView"
    private var dataSource: [DiffItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout.estimatedItemSize = CGSize(width: 325, height: 100)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        populateDataSource()
    }
    
    private func populateDataSource() {
        let diffBridge = WMFDiffBridge()
        let string2 = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Praesent at risus in ligula interdum venenatis. Ut metus. Maecenas elementum. Aenean volutpat turpis quis sem. In nec orci at purus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Pellentesque sit amet odio. Phasellus ut nulla. Sed nulla. Nulla posuere, metus ac eleifend vehicula, felis justo venenatis urna, in sagittis tortor tortor vitae tellus. Nam pellentesque dui eu dui. Nullam adipiscing. Nullam non arcu. Nunc magna sem, viverra sed, ultrices a, placerat et, nulla. Ut orci dui, ultricies a, congue id, interdum sit amet, purus. Donec quis leo ac loblah blah rem rhoncus sodales. Proin pulvinar consequat libero. Sed dictum, nulla id laoreet consequat, elit justo ornare lectus, eget imperdiet mauris ligula vel nunc.\n\nAenean a elit. Mauris scelerisque malesuada ligula. Curabitur pretium. Duis est diam, venenatis ac, rutrum in, fringilla non, neque. Ut auctor leo id nulla. Nam ultricies. Vestibulum a erat eget mi posuere vestibulum. Nunc venenatis. Donec tristique tempus quam. Nunc id libero nec leo rhoncus lacinia. Donec tincidunt tellus ut magna. Quisque nisl. Fusce posuere pharetra tellus. Curabitur iaculis, lorem sit amet suscipit aliquet, nisl massa laoreet enim, vel elementum risus leo ac diam. Curabitur quis augue semper erat ultrices pharetra.Praesent ipsum. Vivamus ultricies, justo in viverra venenatis, enim mi imperdiet metus, vel adipiscing purus nisl nec turpis. Sed eget augue. In hac habitasse platea dictumst. Pellentesque iaculis. Nam vestibulum eros ut justo. Quisque semper diam semper eros sagittis pulvinar. In posuere aliquam pede. Sed euismod sagittis est.\n\nDonec pellentesque. Pellentesque nec massa vel leo scelerisque lacinia. Praesent a lectus. Praesent mattis ligula vitae tellus. Mauris dapibus purus sed tellus. Praesent elementum nonummy dolor. Fusce semper libero eu ipsum. Aliquam faucibus. Integer lectus diam, egestas vitae, imperdiet quis, molestie vitae, leo. Donec sagittis ligula sit amet sem. Morbi tincidunt sem eget lacus. Nulla pharetra. Quisque risus dolor, mollis id, lacinia non, aliquet eget, diam. Nunc sagittis. Cras mauris. Duis augue urna, posuere at, pretium a, ultrices eu, velit. Vivamus dolor massa, posuere non, fermentum vitae, consectetuer eu, diam. Nullam consectetuer, felis a congue commodo, risus nulla sodales dui, at congue risus augue eu nisl. Integer ac elit. Praesent ante ipsum, consequat vel, tincidunt et, bibendum non, mauris. Nulla vehicula pede non enim. In tempor. Nam enim odio, venenatis non, faucibus semper, semper nec, dui. Mauris sit amet lectus. Fusce semper dui. Fusce felis.\n\nDonec posuere condimentum erat. Fusce auctor. Sed porta, tortor non tempor lacinia, lacus lacus venenatis dui, et hendrerit risus metus et mi. Curabitur libero quam, tempus id, pharetra sed, porttitor semper, purus. Cras ac augue. Ut accumsan elit at pede.\n\nIn enim. Donec at mi. Maecenas ante sapien, faucibus ut, luctus non, volutpat eget, lectus. Praesent fermentum sollicitudin diam. Curabitur eget odio. Sed sed libero. Nam tempus blandit lacus. Nam dapibus. Donec malesuada tincidunt neque. Aenean nunc ligula, posuere vel, rutrum vitae, tincidunt id, wisi. Quisque semper elit semper sem posuere sodales. Sed pellentesque leo semper dolor. Cras id arcu. Nunc at urna eu dui tristique consectetuer. Nunc risus. Fusce gravida mi eu justo. Aliquam posuere, risus ut tincidunt sodales, mi lectus varius ipsum, sit amet rutrum metus pede quis elit.\n\nNew paragraph here.\n\nFusce sodales felis et tortor. Mauris volutpat viverra sapien. "
        let string1 = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Praesent at risus in ligula interdum venenatis. Ut metus. Maecenas elementum. Aenean volutpat turpis quis sem. In nec orci at purus mollis accumsan. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Pellentesque sit amet odio. Phasellus ut nulla. Sed nulla. Nulla posuere, metus ac eleifend vehicula, felis justo venenatis urna, in sagittis tortor tortor vitae tellus. Nam pellentesque dui eu dui. Nullam adipiscing. Nullam non arcu. Nunc magna sem, viverra sed, ultrices a, placerat et, nulla. Ut orci dui, ultricies a, congue id, interdum sit amet, purus. Donec quis leo ac lorem rhoncus sodales. Proin pulvinar consequat libero. Sed dictum, nulla id laoreet consequat, elit justo ornare lectus, eget imperdiet mauris ligula vel nunc.\n\nFusce rutrum risus ut enim. Fusce porta vulputate sem. Mauris viverra. Maecenas ut nisl in purus tincidunt tincidunt. Vestibulum feugiat dictum velit. Aliquam erat volutpat. Aliquam iaculis, turpis quis faucibus tristique, wisi leo auctor est, vel pulvinar tellus turpis non elit. Fusce nisl. Pellentesque arcu. Donec metus. Pellentesque vitae magna. Mauris egestas. Donec mollis. Donec imperdiet consequat odio. Cras odio orci, luctus vitae, varius nec, mollis et, ante. Sed augue. Aliquam et nibh.\n\nAenean a elit. Mauris scelerisque malesuada ligula. Curabitur pretium. Duis est diam, venenatis ac, rutrum in, fringilla non, neque. Ut auctor leo id nulla. Nam ultricies. Vestibulum a erat eget mi posuere vestibulum. Nunc venenatis. Donec tristique tempus quam. Nunc id libero nec leo rhoncus lacinia. Donec tincidunt tellus ut magna. Quisque nisl. Fusce posuere pharetra tellus. Curabitur iaculis, lorem sit amet suscipit aliquet, nisl massa laoreet enim, vel elementum risus leo ac diam. Curabitur quis augue semper erat ultrices pharetra.Praesent ipsum. Vivamus ultricies, justo in viverra venenatis, enim mi imperdiet metus, vel adipiscing purus nisl nec turpis. Sed eget augue. In hac habitasse platea dictumst. Pellentesque iaculis. Nam vestibulum eros ut justo. Quisque semper diam semper eros sagittis pulvinar. In posuere aliquam pede. Sed euismod sagittis est.\n\nDonec posuere condimentum erat. Fusce auctor. Sed porta, tortor non tempor lacinia, lacus lacus venenatis dui, et hendrerit risus metus et mi. Curabitur libero quam, tempus id, pharetra sed, porttitor semper, purus. Cras ac augue. Ut accumsan elit at pede.\n\nDonec pellentesque. Pellentesque nec massa vel leo scelerisque lacinia. Praesent a lectus. Praesent mattis ligula vitae tellus. Mauris dapibus purus sed tellus. Praesent elementum nonummy dolor. Fusce semper libero eu ipsum. Aliquam faucibus. Integer lectus diam, egestas vitae, imperdiet quis, molestie vitae, leo. Donec sagittis ligula sit amet sem. Morbi tincidunt sem eget lacus. Nulla pharetra. Quisque risus dolor, mollis id, lacinia non, aliquet eget, diam. Nunc sagittis. Cras mauris. Duis augue urna, posuere at, pretium a, ultrices eu, velit. Vivamus dolor massa, posuere non, fermentum vitae, consectetuer eu, diam. Nullam consectetuer, felis a congue commodo, risus nulla sodales dui, at congue risus augue eu nisl. Integer ac elit. Praesent ante ipsum, consequat vel, tincidunt et, bibendum non, mauris. Nulla vehicula pede non enim. In tempor. Nam enim odio, venenatis non, faucibus semper, semper nec, dui. Mauris sit amet lectus. Fusce semper dui. Fusce felis.\n\nIn enim. Donec at mi. Maecenas ante sapien, faucibus ut, luctus non, volutpat eget, lectus. Praesent fermentum sollicitudin diam. Curabitur eget odio. Sed sed libero. Nam tempus blandit lacus. Nam dapibus. Donec malesuada tincidunt neque. Aenean nunc ligula, posuere vel, rutrum vitae, tincidunt id, wisi. Quisque semper elit semper sem posuere sodales. Sed pellentesque leo semper dolor. Cras id arcu. Nunc at urna eu dui tristique consectetuer. Nunc risus. Fusce gravida mi eu justo. Aliquam posuere, risus ut tincidunt sodales, mi lectus varius ipsum, sit amet rutrum metus pede quis elit.\n\nFusce sodales felis et tortor. Mauris volutpat viverra sapien. "
        if let diff = diffBridge.diffResults(fromString1: string1, andString2: string2),
            let data = diff.data(using: String.Encoding.utf8) {
            do {
                let response = try JSONDecoder().decode(DiffResponse.self, from: data)
                dataSource = response.diffs
                collectionView.reloadData()
            } catch (let error) {
                print(error)
            }
        }
    }
}

extension DiffPrototypeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let diffCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? DiffPrototypeCell,
        let item = dataSource?[safeIndex: indexPath.item] else {
            return UICollectionViewCell()
        }
        
        diffCell.configure(item: item, width: collectionView.bounds.width)
        
        return diffCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()

//        guard kind == UICollectionView.elementKindSectionHeader,
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderReuseIdentifier, for: indexPath) as? DiffPrototypeSectionHeader,
//            let item = dataSource?[safeIndex: indexPath.item] else {
//            return UICollectionReusableView()
//        }
//
//        header.configure(text: group.sectionText)
//
//        return header
    }
}

extension DiffPrototypeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
//        guard let group = dataSource?[safeIndex: section] else {
//                return .zero
//        }
//
//        return CGSize(width: collectionView.bounds.width, height: group.sectionTextHeight + DiffPrototypeSectionHeader.paddingVertical)
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    func cleaned() -> String {
        let cleanedContent = self.deletingPrefix("<td class=\"diff-addedline\">").deletingPrefix("<td class=\"diff-addedline\"/>").deletingPrefix("<td class=\"diff-deletedline\">").deletingPrefix("<td class=\"diff-deletedline\"/>").deletingPrefix("<td colspan=\"2\" class=\"diff-empty\">").deletingPrefix("<div>").deletingSuffix("</td>").deletingSuffix("</div>")
        
        let finalContent = cleanedContent.count > 0 ? cleanedContent : "\n"
        
        return finalContent
    }
}

extension StringProtocol {
    func nsRange(from range: Range<Index>) -> NSRange {
        return .init(range, in: self)
    }
}
