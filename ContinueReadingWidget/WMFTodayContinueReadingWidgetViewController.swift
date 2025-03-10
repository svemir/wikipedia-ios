import UIKit
import NotificationCenter
import WMF

class WMFTodayContinueReadingWidgetViewController: ExtensionViewController, NCWidgetProviding {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var daysAgoView: UIView!
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    @IBOutlet weak var emptyDescriptionLabel: UILabel!

    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabelTrailingConstraint: NSLayoutConstraint!
    
    var articleURL: URL?
    
    override func apply(theme: Theme) {
        super.apply(theme: theme)
        guard viewIfLoaded != nil else {
            return
        }
        titleLabel.textColor = theme.colors.primaryText
        textLabel.textColor = theme.colors.secondaryText
        emptyTitleLabel.textColor = theme.colors.primaryText
        emptyDescriptionLabel.textColor = theme.colors.secondaryText
        daysAgoLabel.textColor = theme.colors.overlayText
        daysAgoView.backgroundColor = theme.colors.overlayBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.accessibilityIgnoresInvertColors = true
        
        emptyDescriptionLabel.text = WMFLocalizedString("continue-reading-empty-title", value:"No recently read articles", comment: "No recently read articles")
        emptyDescriptionLabel.text = WMFLocalizedString("continue-reading-empty-description", value:"Explore Wikipedia for more articles to read", comment: "Explore Wikipedia for more articles to read")
        _ = updateView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureRecognizer(_:))))
    }
    

    
    @objc func handleTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            continueReading(self)
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = updateView()
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        let didUpdate = updateView()
        
        if didUpdate {
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
    
    var emptyViewHidden: Bool = false {
        didSet {
            emptyView.isHidden = emptyViewHidden
            
            titleLabel.isHidden = !emptyViewHidden
            textLabel.isHidden = !emptyViewHidden
            imageView.isHidden = !emptyViewHidden
            daysAgoView.isHidden = !emptyViewHidden
        }
    }

    var collapseImageAndWidenLabels: Bool = true {
        didSet {
            imageWidthConstraint.constant = collapseImageAndWidenLabels ? 0 : 86
            titleLabelTrailingConstraint.constant = collapseImageAndWidenLabels ? 0 : 10
            self.imageView.alpha = self.collapseImageAndWidenLabels ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
    
    func updateView() -> Bool {
        guard let session = SessionSingleton.sharedInstance() else {
            return false
        }
        
        let article: WMFArticle
        
        if let openArticleURL = session.dataStore.viewContext.openArticleURL, let openArticle = session.dataStore.historyList.entry(for: openArticleURL) {
            article = openArticle
        } else if let mostRecentHistoryEntry = session.dataStore.historyList.mostRecentEntry() {
            article = mostRecentHistoryEntry
        } else {
            return false
        }
        
        let newArticleURL: URL?
        if let fragment = article.viewedFragment {
            newArticleURL = article.url?.wmf_URL(withFragment: fragment)
        } else {
            newArticleURL = article.url
        }
        
        guard newArticleURL != nil, newArticleURL?.absoluteString != articleURL?.absoluteString else {
            return false
        }

        articleURL = newArticleURL
        
        textLabel.text = nil
        titleLabel.text = nil
        imageView.image = nil
        imageView.isHidden = true
        daysAgoLabel.text = nil
        daysAgoView.isHidden = true
        emptyViewHidden = true
        
        if let subtitle = article.capitalizedWikidataDescriptionOrSnippet {
            self.textLabel.text = subtitle
        } else {
            self.textLabel.text = nil
        }
        
        if let date = article.viewedDate {
            self.daysAgoView.isHidden = false
            self.daysAgoLabel.text = (date as NSDate).wmf_localizedRelativeDateStringFromLocalDateToNow()
        } else {
            self.daysAgoView.isHidden = true
        }
        
        self.titleLabel.attributedText = article.displayTitleHTML.byAttributingHTML(with: .headline, matching: traitCollection)
        
        if let imageURL = article.imageURL(forWidth: self.traitCollection.wmf_nearbyThumbnailWidth) {
            self.collapseImageAndWidenLabels = false
            self.imageView.wmf_setImage(with: imageURL, detectFaces: true, onGPU: true, failure: { (error) in
                self.collapseImageAndWidenLabels = true
            }) {
                self.collapseImageAndWidenLabels = false
            }
        } else {
            self.collapseImageAndWidenLabels = true
        }
        
        var fitSize = UIView.layoutFittingCompressedSize
        fitSize.width = view.bounds.size.width
        fitSize = view.systemLayoutSizeFitting(fitSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        preferredContentSize = fitSize
        
        return true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        _ = updateView()
    }

    @IBAction func continueReading(_ sender: AnyObject) {
        let URL = articleURL as NSURL?
        let URLToOpen = URL?.wmf_wikipediaScheme ?? NSUserActivity.wmf_baseURLForActivity(of: .explore)
        
        self.extensionContext?.open(URLToOpen)
    }


}

