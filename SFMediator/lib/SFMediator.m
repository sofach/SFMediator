//
//  SFMediator.m
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import "SFMediator.h"

@interface SFMediator ()

@property (strong, nonatomic) NSCache *cachedTarget;

@end

@implementation SFMediator

+ (instancetype)sharedInstence {
    static id sharedInstence = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstence = [[self alloc] init];
    });
    return sharedInstence;
}

+ (NSDictionary *)paramsFromUrl:(NSURL *)url {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    return params;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _cachedTarget = [[NSCache alloc] init];
    }
    return self;
}

- (id)targetFromTargetName:(NSString *)targetName {
    if (!targetName) {
        return nil;
    }
    id target = [self.cachedTarget objectForKey:targetName];
    if (target) {
        return target;
    }
    
    Class targetClass = NSClassFromString(targetName);
    if (!targetClass && _prefix) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@%@", _prefix, targetName]);
    }
    if (!targetClass) {
        return nil;
    }
    
    target = [[targetClass alloc] init];
    [self.cachedTarget setObject:target forKey:targetName];
    return target;
}

- (id)mediateTarget:(NSString *)targetName params:(NSDictionary *)params {
    
    id target = [self targetFromTargetName:targetName];
    if (!target) {
        NSLog(@"mediate target not found:%@", targetName);
        return nil;
    }
    
    id fromRemote = params[SFMediatorParamKeyFromRemote];
    if (fromRemote && [fromRemote boolValue]) {
        SEL canMediateAction = NSSelectorFromString(@"canMediateTargetFromRemoteWithParams:");
        if (![target respondsToSelector:canMediateAction] || ![[self performSelector:canMediateAction target:target params:params] boolValue]) {
            return nil;
        }
    }
    
    SEL action = NSSelectorFromString(@"mediateTargetWithParams:");
    if ([target respondsToSelector:action]) {
        return [self performSelector:action target:target params:params];
    } else {
        return nil;
    }
}

- (id)mediateRemoteUrl:(NSURL *)url {
    if (!url) {
        return nil;
    }

    NSString *targetName = url.host;
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[SFMediator paramsFromUrl:url]];
    [params setObject:actionName forKey:SFMediatorParamKeyAction];
    [params setObject:@1 forKey:SFMediatorParamKeyFromRemote];
    return [self mediateTarget:targetName params:params];
}

- (id)performSelector:(SEL)aSelector target:(id)target params:(NSDictionary *)params {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:aSelector withObject:params];
#pragma clang diagnostic pop
}

@end
