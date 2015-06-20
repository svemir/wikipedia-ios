
#import "WMFArticleViewController.h"
#import "MWKSection.h"
#import <Masonry/Masonry.h>
#import <DTCoreText/DTCoreText.h>

@interface WMFArticleViewController ()
@property (weak, nonatomic) IBOutlet DTAttributedTextView* htmlView;
@end

@implementation WMFArticleViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyDefaultProperties];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self applyDefaultProperties];
    }
    return self;
}

- (void)applyDefaultProperties {
    self.articleViewMode = WMFArticleViewModeCompact;
}

- (void)setContentTopInset:(CGFloat)contentTopInset {
    if (contentTopInset == _contentTopInset) {
        return;
    }

    _contentTopInset = contentTopInset;

    [self updateContentForTopInset];
}

- (void)updateContentForTopInset {
    if (![self isViewLoaded]) {
        return;
    }

    [self.htmlView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.mas_top).with.offset(self.contentTopInset);
    }];
}

#pragma mark - Accessors

- (void)setArticle:(MWKArticle*)article {
    if ([_article isEqual:article]) {
        return;
    }

    _article = article;

    if ([self isViewLoaded]) {
        [self updateUIAnimated:YES];
    }
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    self.view.layer.borderWidth = 4.f;
    self.view.backgroundColor = [UIColor clearColor];
    [self updateContentForTopInset];
    [self updateUIAnimated:NO];
    [self applyArticleViewMode];
}

#pragma mark UI Updates

- (void)setArticleViewMode:(WMFArticleViewMode)articleViewMode {
    if (_articleViewMode == articleViewMode) {
        return;
    }
    _articleViewMode = articleViewMode;
    if ([self isViewLoaded]) {

    }
}

- (void)applyArticleViewMode {
    self.htmlView.userInteractionEnabled = self.articleViewMode == WMFArticleViewModeRegular;
    [self updateUIAnimated:NO];
}

- (NSRange)sectionRangeForViewMode {
    return self.articleViewMode == WMFArticleViewModeCompact ? NSMakeRange(0, 1) : NSMakeRange(0, 5);
}

- (void)updateUIAnimated:(BOOL)animated {
    self.htmlView.attributedString =
        [[NSAttributedString alloc]
         initWithHTMLData:[self.article.sections aggregatedDataFromSections:[self sectionRangeForViewMode]]
                   baseURL:self.article.site.URL
        documentAttributes:nil];
}

@end
