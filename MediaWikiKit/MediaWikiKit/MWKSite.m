//  Created by Brion on 11/6/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "MediaWikiKit.h"
#import "NSObjectUtilities.h"
#import "NSString+WMFPageUtilities.h"

NSString* const WMFDefaultSiteDomain = @"wikipedia.org";

static NSString* const MWKSiteSchemaVersionKey = @"siteSchemaVersion";

typedef NS_ENUM (NSUInteger, MWKSiteNSCodingSchemaVersion) {
    MWKSiteNSCodingSchemaVersion_1 = 1
};

@interface MWKSite ()

@property (readwrite, copy, nonatomic) NSString* domain;
@property (readwrite, copy, nonatomic) NSString* language;

@end

@implementation MWKSite

- (instancetype)initWithDomain:(NSString*)domain language:(NSString*)language {
    NSParameterAssert(domain.length);
    NSParameterAssert(language.length);
    self = [super init];
    if (self) {
        self.domain   = domain;
        self.language = language;
    }
    return self;
}

- (instancetype)initWithLanguage:(NSString*)language {
    return [self initWithDomain:WMFDefaultSiteDomain language:language];
}

- (instancetype)initWithURL:(NSURL * __nonnull)url {
    if (!url.absoluteString.length) {
        return nil;
    }
    NSURLComponents* urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES];
    if ([urlComponents.host containsString:@"wikipedia.org"] && [urlComponents.path wmf_isInternalLink]) {
        NSArray* hostComponents = [urlComponents.host componentsSeparatedByString:@"."];
        NSString* language = hostComponents.firstObject;
        return [self initWithDomain:[urlComponents.host substringFromIndex:language.length] language:language];
    } else {
        DDLogWarn(@"Attempted to parse non-wikipedia URL: %@", url);
        return nil;
    }
}

+ (instancetype)siteWithLanguage:(NSString*)language {
    return [[self alloc] initWithLanguage:language];
}

+ (MWKSite*)siteWithDomain:(NSString*)domain language:(NSString*)language {
    return [[MWKSite alloc] initWithDomain:domain language:language];
}

+ (instancetype)siteWithCurrentLocale {
    return [self siteWithLocale:[NSLocale currentLocale]];
}

+ (instancetype)siteWithLocale:(NSLocale*)locale {
    return [self siteWithDomain:WMFDefaultSiteDomain language:[locale objectForKey:NSLocaleLanguageCode]];
}

#pragma mark - Title Helpers

- (MWKTitle*)titleWithString:(NSString*)string {
    return [MWKTitle titleWithString:string site:self];
}

- (MWKTitle*)titleWithInternalLink:(NSString*)path {
    return [[MWKTitle alloc] initWithInternalLink:path site:self];
}

#pragma mark - Computed Properties

- (NSURL*)mobileApiEndpoint {
    return [[self apiURLComponents:YES] URL];
}

- (NSURL*)apiEndpoint {
    return [[self apiURLComponents:NO] URL];
}

- (NSURL*)URL {
    return [[self siteURLComponents:NO] URL];
}

- (NSURLComponents*)apiURLComponents:(BOOL)isMobile {
    NSURLComponents* apiURLComponents = [self siteURLComponents:NO];
    apiURLComponents.path = @"/w/api.php";
    return apiURLComponents;
}

- (NSURLComponents*)siteURLComponents:(BOOL)isMobile {
    NSURLComponents* siteURLComponents = [[NSURLComponents alloc] init];
    siteURLComponents.scheme = @"https";
    NSMutableArray* hostComponents = [NSMutableArray arrayWithObject:self.language];
    if (isMobile) {
        [hostComponents addObject:@"m"];
    }
    [hostComponents addObject:self.domain];
    siteURLComponents.host = [hostComponents componentsJoinedByString:@"."];
    return siteURLComponents;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (object == nil) {
        return NO;
    } else if ([object isKindOfClass:[MWKSite class]]) {
        return [self isEqualToSite:object];
    } else {
        return NO;
    }
}

- (BOOL)isEqualToSite:(MWKSite*)other {
    return WMF_EQUAL_PROPERTIES(self, language, isEqualToString:, other)
           && WMF_EQUAL_PROPERTIES(self, domain, isEqualToString:, other);
}

- (NSUInteger)hash {
    return self.domain.hash ^ flipBitsWithAdditionalRotation(self.language.hash, 1);
}

- (id)copyWithZone:(NSZone*)zone {
    // immutable
    return self;
}

@end
