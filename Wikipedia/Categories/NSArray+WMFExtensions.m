//
//  NSArray+WMFExtensions.m
//  Wikipedia
//
//  Created by Corey Floyd on 2/18/15.
//  Copyright (c) 2015 Wikimedia Foundation. All rights reserved.
//

#import "NSArray+WMFExtensions.h"

@implementation NSArray (WMFExtensions)

- (NSArray*)wmf_safeSubarrayWithRange:(NSRange)range {
    if (self.count == 0 || range.location > self.count - 1 || range.length == 0) {
        return @[];
    }
    return [self subarrayWithRange:
            NSMakeRange(range.location,
                        MIN(self.count - range.location, range.length))];
}

- (id)wmf_safeObjectAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

- (instancetype)wmf_arrayByTrimmingToLength:(NSUInteger)length {
    if ([self count] == 0) {
        return self;
    }

    if ([self count] < length) {
        return self;
    }

    return [self subarrayWithRange:NSMakeRange(0, length)];
}

- (instancetype)wmf_reverseArray {
    return [[self reverseObjectEnumerator] allObjects];
}

@end
