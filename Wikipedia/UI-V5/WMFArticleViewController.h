
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, WMFArticleViewMode) {
    WMFArticleViewModeCompact,
    WMFArticleViewModeRegular
};

@interface WMFArticleViewController : UIViewController

@property (nonatomic, assign) WMFArticleViewMode articleViewMode;

@property (nonatomic, assign) CGFloat contentTopInset;

@property (nonatomic, strong) MWKArticle* article;

@end
