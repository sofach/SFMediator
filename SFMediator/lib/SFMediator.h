//
//  SFMediator.h
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFMediatorTarget.h"

//参考CTMediator的一个中间件，把mediator和target规范化，action只是一个string，没有关联url，放在params中，
@interface SFMediator : NSObject

//target的前缀，比如prefix=SF，那么targetName=Mediator或SFMediator都能找到SFMediator这个Class
@property (strong, nonatomic) NSString *prefix;

+ (instancetype)sharedInstence;

- (id)mediateTarget:(NSString *)targetName params:(NSDictionary *)params;
- (id)mediateRemoteUrl:(NSURL *)url;

@end
