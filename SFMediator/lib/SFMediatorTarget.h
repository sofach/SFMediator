//
//  SFMediatorTarget.h
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SFMediatorParamKeyFromRemote @"fromRemote"
#define SFMediatorParamKeyAction @"appAction"

@protocol SFMediateTargetProtocol <NSObject>

- (id)mediateTargetWithParams:(NSDictionary *)params;
- (id)canMediateTargetFromRemoteWithParams:(NSDictionary *)params;

@end

@interface SFMediatorTarget : NSObject <SFMediateTargetProtocol>

@end
