
#import <UIKit/UIKit.h>

@interface UIStoryboard (WMFExtensions)

+ (UIStoryboard*)wmf_appRootStoryBoard;

- (id)wmf_instnatiateViewControllerWithIdentifierFromClassName:(Class)viewControllerClass;

@end
