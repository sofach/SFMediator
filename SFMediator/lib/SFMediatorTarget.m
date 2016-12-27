//
//  SFMediatorTarget.m
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import "SFMediatorTarget.h"

@implementation SFMediatorTarget

- (id)mediateTargetWithParams:(NSDictionary *)params {
    
    NSString *action = params[SFMediatorParamKeyAction];
    if (!action) {
        NSLog(@"warn: mediate action not found:%@", params);
        return nil;
    }
    NSLog(@"warn: no target mediate action:%@", action);
    return nil;
}

- (id)canMediateTargetFromRemoteWithParams:(NSDictionary *)params {
    return @0;
}

@end
