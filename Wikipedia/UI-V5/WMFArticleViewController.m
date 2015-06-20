
#import "WMFArticleViewController.h"
#import "MWKSection.h"
#import <Masonry/Masonry.h>
#import <DTCoreText/DTCoreText.h>

@interface WMFArticleViewController ()
@property (weak, nonatomic) IBOutlet DTAttributedTextView* htmlView;
@end

@implementation WMFArticleViewController

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
    self.htmlView.scrollEnabled = NO;
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    self.view.layer.borderWidth = 4.f;
    self.view.backgroundColor = [UIColor clearColor];
    [self updateContentForTopInset];
    [self updateUIAnimated:NO];

    // Do any additional setup after loading the view.
}

#pragma mark UI Updates

- (void)updateUIAnimated:(BOOL)animated {
    NSData* firstSectionData = [self.article.sections[0].text dataUsingEncoding:NSUTF8StringEncoding];
    self.htmlView.attributedString =
        [[NSAttributedString alloc] initWithHTMLData:firstSectionData
                                             baseURL:self.article.site.URL
                                  documentAttributes:nil];
}

@end
