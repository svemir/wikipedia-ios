
#import "WMFDiffBridge.h"
#import "DiffHandler.hpp"
#import "Wikidiff2.h"
#import <string>

@interface WMFDiffBridge () {
    DiffHandler diffHandler;
}
@end

@implementation WMFDiffBridge

- (NSString *)diffResultsFromString1:(NSString *)string1 andString2:(NSString *)string2 {

    std::string cppString1([string1 cStringUsingEncoding:NSUTF8StringEncoding]);
    std::string cppString2([string1 cStringUsingEncoding:NSUTF8StringEncoding]);
    
    const char *c = [string1 UTF8String];
    const char *bs = [string2 UTF8String];
    
    NSString *results = [NSString stringWithCString:diffHandler.diff(c, bs).c_str() encoding:NSUTF8StringEncoding];
    
    return results;
}

@end
