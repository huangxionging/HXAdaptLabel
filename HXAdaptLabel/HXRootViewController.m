//
//  HXRootViewController.m
//  HXAdaptLabel
//
//  Created by huangxiong on 14/12/23.
//  Copyright (c) 2014年 New_Life. All rights reserved.
//

#import "HXRootViewController.h"
#import "HXNavigationController.h"
#import "HXAdaptViewController.h"

@interface HXRootViewController ()

@end

@implementation HXRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    [self performSelector: @selector(changeController) withObject: nil afterDelay: 0.1];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"ssssss");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeController
{
    HXAdaptViewController *adaptViewController = [[HXAdaptViewController alloc] init];
    HXNavigationController *navigationController = [[HXNavigationController alloc] initWithRootViewController: adaptViewController];
    [self presentViewController: navigationController animated:NO completion:^{
        NSLog(@"模态成功");
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
