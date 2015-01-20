//
//  HXViewController.m
//  HXAdaptLabel
//
//  Created by huangxiong on 14/12/24.
//  Copyright (c) 2014年 New_Life. All rights reserved.
//

#import "HXViewController.h"

#define TITLE_WIDTH (200)
#define TITLE_HEIGHT (20)

@interface HXViewController ()

@end

@implementation HXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomNavigationBar];
    [self.view setBackgroundColor: [UIColor whiteColor]]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---创建导航栏
- (void)setCustomNavigationBar
{
    // 创建导航栏
    _customNavigationBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 20, 320, 44)];
    _customNavigationBar.image = [UIImage imageNamed: @"navigation"];
    _customNavigationBar.userInteractionEnabled = YES;
    [self.view addSubview: _customNavigationBar];
}

#pragma mark---创建左导航按钮
- (void) setNavigationLeftButtonWithNormalImage: (NSString *) normalImage andHighLightImage: (NSString *)highImage
{
    if (normalImage != nil && _leftButton == nil)
    {
        [self setLeftButton];
        [_leftButton setImage: [UIImage imageNamed: normalImage] forState: UIControlStateNormal];
        
        if (highImage != nil)
        {
            [_leftButton setImage: [UIImage imageNamed: highImage] forState: UIControlStateHighlighted];
        }
        
        // 添加点击事件
        [_leftButton addTarget: self action: @selector(navigationBarLeftClick:) forControlEvents: UIControlEventTouchUpInside];
    }
}

#pragma mark---创建右导航按钮
- (void) setNavigationRightButtonWithNormalImage:(NSString *)normalImage andHighLightImage:(NSString *)highImage
{
    if (normalImage != nil && _leftButton == nil)
    {
        [self setRightButton];
        [_rightButton setBackgroundImage: [UIImage imageNamed: normalImage] forState: UIControlStateNormal];
        
        if (highImage != nil)
        {
            [_rightButton setBackgroundImage: [UIImage imageNamed: normalImage] forState: UIControlStateNormal];
        }
        
        // 添加点击事件
        [_rightButton addTarget: self action: @selector(navigationBarRightClick:) forControlEvents: UIControlEventTouchUpInside];
    }
}


#pragma mark---创建左按钮
- (void) setLeftButton
{
    // 创建左导航按钮
    if (_leftButton != nil)
    {
        return;
    }
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_customNavigationBar addSubview: _leftButton];
}

#pragma mark---创建右导航按钮
- (void) setRightButton
{
    // 创建右导航按钮
    if (_rightButton != nil)
    {
        return;
    }
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
    [_customNavigationBar addSubview: _rightButton];
}

#pragma mark---左导航按钮点击事件
- (void) navigationBarLeftClick: (UIButton *) sender
{
    
}

#pragma mark---右导航按钮点击事件
- (void) navigationBarRightClick: (UIButton *) sender
{
    
}

#pragma mark---通过标题创建
- (void) setNavigationLeftTitle:(NSString *)leftTitle
{
    if (leftTitle == nil)
    {
        return;
    }
    
    [self setLeftButton];
    
    [_leftButton setTitle: leftTitle forState: UIControlStateNormal];
    [_leftButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_leftButton setTitleColor: [UIColor purpleColor] forState: UIControlStateHighlighted];
    _leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    // 添加点击事件
    [_leftButton addTarget: self action: @selector(navigationBarLeftClick:) forControlEvents: UIControlEventTouchUpInside];
}

#pragma mark---通过右标题创建导航按钮
- (void) setNavigationRightTitle:(NSString *)rightTitle
{
    if (rightTitle == nil)
    {
        return;
    }
    
    [self setRightButton];
    
    [_rightButton setTitle: rightTitle forState: UIControlStateNormal];
    [_rightButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_rightButton setTitleColor: [UIColor purpleColor] forState: UIControlStateHighlighted];
    _rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    // 添加点击事件
    [_rightButton addTarget: self action: @selector(navigationBarRightClick:) forControlEvents: UIControlEventTouchUpInside];
}

#pragma mark---创建标题
- (void) setNavigationTitle: (NSString *) titleName
{
    if (titleName == nil)
    {
        return;
    }
    
    // 标题标签的位置
    _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake((SCREEN_WIDTH - TITLE_WIDTH) / 2, (44 - TITLE_HEIGHT) / 2, TITLE_WIDTH, TITLE_HEIGHT)];
    [_customNavigationBar addSubview: _titleLabel];
    
    // 设置标题标签的属性
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = titleName;
}

#pragma mark---设置标题视图
- (void) setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = nil;
    _titleView = titleView;
    [_customNavigationBar addSubview: _titleView];
}

- (void) showMessage: (NSString *)message
{
    if (IOS8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"温馨提示" message: message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated: YES completion:^{
                
            }];
        }]];
        
        [self presentViewController: alert animated: YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"确定", nil];
        [alertView show];
    }
}

@end
