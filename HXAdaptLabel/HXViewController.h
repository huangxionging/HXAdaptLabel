//
//  HXViewController.h
//  HXAdaptLabel
//
//  Created by huangxiong on 14/12/24.
//  Copyright (c) 2014年 New_Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXViewController : UIViewController

/**
 *  导航栏
 */
@property (nonatomic, strong) UIImageView *customNavigationBar;

/**
 *  左导航按钮
 */
@property (nonatomic, strong) UIButton *leftButton;

/**
 *  右导航按钮
 */
@property (nonatomic, strong) UIButton *rightButton;

/**
 *  标题视图
 */
@property (nonatomic, strong) UIView *titleView;

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  @brief: 创建导航栏
 *  @param: 无
 *  @return:无
 */
- (void) setCustomNavigationBar;

/**
 *  @brief: 创建左按钮
 *  @param: 无
 *  @return:无
 */
- (void) setNavigationLeftButtonWithNormalImage: (NSString *) normalImage andHighLightImage: (NSString *)highImage;


/**
 *  @brief: 创建右按钮
 *  @param: 无
 *  @return:无
 */
- (void) setNavigationRightButtonWithNormalImage: (NSString *) normalImage andHighLightImage: (NSString *)highImage;

/**
 *  @brief: 创建左标题
 *  @param: 无
 *  @return:无
 */
- (void) setNavigationLeftTitle: (NSString *)leftTitle;

/**
 *  @brief: 创建右标题
 *  @param: 无
 *  @return:无
 */
- (void) setNavigationRightTitle: (NSString *)rightTitle;

/**
 *  @brief: 左按钮的点击事件
 *  @param: 无
 *  @return:无
 */
- (void) navigationBarLeftClick: (UIButton *) sender;

/**
 *  @brief: 右按钮的点击事件
 *  @param: 无
 *  @return:无
 */
- (void) navigationBarRightClick: (UIButton *) sender;

/**
 *  @brief: 创建标题栏
 *  @param: 无
 *  @return:无
 */
- (void) setNavigationTitle: (NSString *) titleName;

/**
 *  @brief: 展示提示信息
 *  @param: message 是要提示的信息
 *  @return:无
 */
- (void) showMessage: (NSString *)message;

@end
