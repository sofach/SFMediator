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

- (id)performSelector:(SEL)aSelector target:(id)target action:(NSString *)action params:(NSDictionary *)params {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:aSelector withObject:action withObject:params];
#pragma clang diagnostic pop
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


#pragma mark - public method
- (id)mediateTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params {
    return [self mediateTarget:targetName action:actionName isRemote:NO params:params];
}

- (id)mediateTarget:(NSString *)targetName action:(NSString *)actionName isRemote:(BOOL)isRemote params:(NSDictionary *)params {
    
    if (!targetName || !actionName) {
        NSLog(@"[warn] mediate target or action can't be nil");
        return nil;
    }
    
    id target = [self targetFromTargetName:targetName];
    if (!target) {
        NSLog(@"[error] mediate target not found:%@", targetName);
        return nil;
    }
    
    //远程调用，需要先验证这个action是否支持远程调用
    if (isRemote) {
        
        SEL canMediateSelector = NSSelectorFromString(@"canMediateRemoteAction:params:");
        if (![target respondsToSelector:canMediateSelector] || ![[self performSelector:canMediateSelector target:target action:actionName params:params] boolValue]) {
            
            NSLog(@"[error] mediate target:%@ can't perform remote action:%@", targetName, actionName);
            return nil;
        }
    }
    
    SEL mediateSelector = NSSelectorFromString(@"mediateAction:params:");
    if ([target respondsToSelector:mediateSelector]) {
        
        return [self performSelector:mediateSelector target:target action:actionName params:params];
    } else {
        NSLog(@"[warn] mediate target：%@ not implements mediateTargetWithParams:", targetName);
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

    return [self mediateTarget:targetName action:actionName isRemote:YES params:params];
}

@end
