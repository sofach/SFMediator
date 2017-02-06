//
//  SFMediator+Demo.m
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import "SFMediator+Demo.h"

@implementation SFMediator (Demo)

- (id)mediate_DemoWithTitle:(NSString *)title color:(UIColor *)color isPresent:(BOOL)present {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:title forKey:@"title"];
    [param setObject:[NSNumber numberWithBool:present] forKey:@"isPresent"];
    [param setObject:color forKey:@"color"];
    return [self mediateTarget:@"MediatorTarget" action:@"presentViewController" params:param];
}

@end
