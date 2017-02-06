//
//  DemoMediatorTarget.m
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import "DemoMediatorTarget.h"
#import "ViewController.h"

@implementation DemoMediatorTarget


- (id)mediateAction:(NSString *)actionName params:(NSDictionary *)params {

    if ([actionName isEqualToString:@"presentViewController"]) {
        NSString *title = params[@"title"];
        BOOL isPresent = [params[@"isPresent"] boolValue];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
        ViewController *myView = [story instantiateViewControllerWithIdentifier:@"VC"];
        [myView setTitle:title color:params[@"color"] isPresent:isPresent];
        return myView;
    } else {
        NSLog(@"[error] action:%@ not support", actionName);
        return nil;
    }

}

- (id)canMediateRemoteAction:(NSString *)actionName params:(NSDictionary *)params {

    if ([actionName isEqualToString:@"presentViewController"]) {
        return @1;
    } else {
        return @0;
    }
}


@end
