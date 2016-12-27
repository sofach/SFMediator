//
//  ViewController.m
//  SFMediator
//
//  Created by 陈少华 on 2016/12/27.
//  Copyright © 2016年 sofach. All rights reserved.
//

#import "ViewController.h"
#import "SFMediator+Demo.h"

@interface ViewController ()

@property (assign, nonatomic) BOOL isPresent;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title color:(UIColor *)color isPresent:(BOOL)isPresent {
    self.view.backgroundColor = color;
    [_clickBtn setTitle:title forState:UIControlStateNormal];
    _isPresent = isPresent;
}

- (IBAction)clickme:(id)sender {
    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        ViewController *vc = [[SFMediator sharedInstence] mediate_DemoWithTitle:@"dismiss" color:[UIColor grayColor] isPresent:YES];
        [self presentViewController:vc animated:YES completion:nil];

    }
}


@end
