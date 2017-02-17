//
//  SFMediator.h
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import <UIKit/UIKit.h>

//参考CTMediator的一个中间件，把target和action规范化
//每个模块需要一个实现协议SFMediateTargetProtocol的target，在target中实现各种action逻辑
@interface SFMediator : NSObject

+ (instancetype)sharedInstence;

- (BOOL)registerTarget:(NSString *)targetName className:(NSString *)className;

//这个是app内部调用的,targetName必须是class名，支持prefix
- (id)mediateTarget:(NSString *)targetName action:(NSString *)action params:(NSDictionary *)params;

//这个是app外部调用的
- (id)mediateRemoteUrl:(NSURL *)url;

@end


//这个是target的协议
@protocol SFMediateTargetProtocol <NSObject>

//处理actionName
- (id)mediateAction:(NSString *)actionName params:(NSDictionary *)params;

@optional
//是否支持远程调用
- (id)canMediateRemoteAction:(NSString *)action params:(NSDictionary *)params;

@end
