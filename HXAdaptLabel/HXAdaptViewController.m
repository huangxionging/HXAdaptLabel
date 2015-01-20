//
//  HXAdaptViewController.m
//  HXAdaptLabel
//
//  Created by huangxiong on 14/12/23.
//  Copyright (c) 2014年 New_Life. All rights reserved.
//

#import "HXAdaptViewController.h"
#import "AdaptLabelModel.h"
#import "AdaptRowlModel.h"
#import "AppDelegate.h"
#import "HXAddLabelViewController.h"


@interface HXAdaptViewController ()<UIActionSheetDelegate>

/**
 *  应用代理
 */
@property (nonatomic, strong) AppDelegate *appDelegate;

/**
 *  标签数组
 */
@property (nonatomic, strong) NSMutableArray *labelArray;

/**
 *  全局临时标签拥挤记录长按手势所在的标签
 */
@property (nonatomic, strong) UILabel *tempLabel;

@end

@implementation HXAdaptViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
               
    [self setNavigationLeftButtonWithNormalImage: @"leftSlide1.png" andHighLightImage: @"leftSlide2.png"];
    [self setNavigationRightTitle: @"+新建"];
    [self setNavigationTitle: @"标签"];
    [self setLabelContainer];
    // 代理
    _appDelegate = [UIApplication sharedApplication].delegate;
    [self setLabels];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(addLabel:) name: @"AddLabel" object: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置标签容器
- (void) setLabelContainer
{
    _labelContainer = [[UIScrollView alloc] initWithFrame: CGRectMake(0, self.customNavigationBar.frame.origin.y + self.customNavigationBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.customNavigationBar.frame.origin.y - self.customNavigationBar.frame.size.height)];
    [self.view addSubview: _labelContainer];
}

#pragma mark---创建标签
- (void) setLabels
{
    if (_labelArray == nil)
    {
        _labelArray = [[NSMutableArray alloc] init];
    }
    // 删除所以数据
    [_labelArray removeAllObjects];
    
    NSArray *array = [self getAdaptLabelData];
    
    if (array.count == 0)
    {
        return;
    }
    
    
    // 添加第一个数据
    AdaptRowlModel *adaptRowModel = [[AdaptRowlModel alloc] init];
    // 默认插入第一条数据
    AdaptLabelModel *adaptLabelModel = array[0];
    [adaptRowModel.adaptLabels addObject: adaptLabelModel];
    adaptRowModel.totalWidth = ((NSNumber *)[adaptLabelModel valueForKey: @"titleWidth"]).integerValue + 15;
    // 加入数组
    [_labelArray addObject: adaptRowModel];
    
    // 分类算法
    for (NSInteger index = 1; index < array.count; ++index)
    {
        AdaptRowlModel *lastObject = [_labelArray lastObject];
        adaptLabelModel = array[index];
        
        NSInteger titleWidth = ((NSNumber *)[adaptLabelModel valueForKey: @"titleWidth"]).integerValue;
        
        // 如果宽度超标
        if (lastObject.totalWidth + titleWidth > 280)
        {
            adaptRowModel = [[AdaptRowlModel alloc] init];
            [adaptRowModel.adaptLabels addObject: adaptLabelModel];
            adaptRowModel.totalWidth = titleWidth + 15;
            [_labelArray addObject: adaptRowModel];
        }
        else
        {
            [lastObject.adaptLabels addObject: adaptLabelModel];
            lastObject.totalWidth += titleWidth + 15;
        }
    }
    
    
    for (NSInteger indexRow = 0; indexRow < _labelArray.count; ++indexRow)
    {
        AdaptRowlModel *rowModel = _labelArray[indexRow];
        NSInteger spaceX = 20;
        for (NSInteger indexColum = 0; indexColum < rowModel.adaptLabels.count; ++indexColum)
        {
            AdaptLabelModel *labelModel = (AdaptLabelModel *)rowModel.adaptLabels[indexColum];
            NSInteger labelWidth = ((NSNumber *)[labelModel valueForKey: @"titleWidth"]).integerValue;
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(spaceX, indexRow * 35 + 20, labelWidth, 20)];
            label.text = [labelModel valueForKey:@"titleName"];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize: 12.0];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 5;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            label.layer.borderWidth = 0.5;
            [_labelContainer addSubview: label];

            // 添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPress:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer: longPressGesture];
            spaceX += labelWidth + 15;
        }
    }
    
    _labelContainer.contentSize = CGSizeMake(0, MAX(SCREEN_HEIGHT - 59, _labelArray.count * 20));
}

#pragma mark---长按手势longPress
- (void) longPress: (UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (IOS8)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil message: nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated: YES completion:^{
                    
                }];
            }]];
            
            [alert addAction: [UIAlertAction actionWithTitle: @"删除标签" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                _tempLabel = (UILabel *)sender.view;
                [self deleteFromCoreDataWith: _tempLabel.text];
                [self resetLabelContainer];
            }]];
            
            [self presentViewController: alert animated: YES completion:^{
                
            }];
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: @"删除标签" otherButtonTitles: nil];
            _tempLabel = (UILabel *)sender.view;
            [actionSheet showInView: self.view];
        }
    }
}

#pragma mark---CoreData获取数据
- (NSArray *) getAdaptLabelData
{
    @synchronized(self)
    {
        // 查询所有相关数据
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"AdaptLabelModel"];
        
        return [_appDelegate.managedObjectContext executeFetchRequest: request error: nil];
    }
}

#pragma mark---右导航按钮的点击事件
- (void) navigationBarRightClick:(UIButton *)sender
{
    HXAddLabelViewController *addLabelViewController = [[HXAddLabelViewController alloc] init];
    [self.navigationController pushViewController: addLabelViewController animated: YES];
}

#pragma mark---添加标签通知
- (void) addLabel: (NSNotification *)notification
{
    AdaptLabelModel *labelModel = [notification.userInfo objectForKey: @"newLabel"];
    NSInteger titleWidth = ((NSNumber *)[labelModel valueForKey: @"titleWidth"]).integerValue;
    
    AdaptRowlModel *lastObject = [_labelArray lastObject];
    if (_labelArray.count == 0)
    {
        AdaptRowlModel *adaptRowModel = [[AdaptRowlModel alloc] init];
        [adaptRowModel.adaptLabels addObject: labelModel];
        adaptRowModel.totalWidth = titleWidth + 15;
        [_labelArray addObject: adaptRowModel];
    }
    else
    {
        // 如果宽度超标
        if (lastObject.totalWidth + titleWidth > 280)
        {
            AdaptRowlModel *adaptRowModel = [[AdaptRowlModel alloc] init];
            [adaptRowModel.adaptLabels addObject: labelModel];
            adaptRowModel.totalWidth = titleWidth + 15;
            [_labelArray addObject: adaptRowModel];
        }
        else
        {
            [lastObject.adaptLabels addObject: labelModel];
            lastObject.totalWidth += titleWidth + 15;
        }
    }
    
    // 获取最后一个元素
    lastObject = [_labelArray lastObject];
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(lastObject.totalWidth - titleWidth + 5, (_labelArray.count - 1) * 35 + 20, titleWidth, 20)];
    label.text = [labelModel valueForKey:@"titleName"];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize: 12.0];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 0.5;
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPress:)];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer: longPressGesture];
    
    [_labelContainer addSubview: label];
}

#pragma mark---通过标题删除
- (void) deleteFromCoreDataWith: (NSString *)titleName
{
    @synchronized(self)
    {
        // 查询所有相关数据
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"AdaptLabelModel"];
        
        // 使用过滤条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF.titleName = %@", titleName];
        
        // 设置过滤条件
        request.predicate = predicate;
        
        NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest: request error: nil];
        
        if (array.count == 0)
        {
            return;
        }
        
        for (AdaptLabelModel *model in array)
        {
            [_appDelegate.managedObjectContext deleteObject: model];
        }
        // 保存删除结果
        [_appDelegate saveContext];
    }
}

#pragma mark---UIActionSheet
- (void)resetLabelContainer
{
    [_tempLabel removeFromSuperview];
    [_labelArray removeAllObjects];
    _labelArray = nil;
    for (UIView *subView in _labelContainer.subviews)
    {
        [subView removeFromSuperview];
    }
    [self setLabels];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case -1:
        {
            break;
        }
        case 0:
        {
            [self deleteFromCoreDataWith: _tempLabel.text];
            [self resetLabelContainer];

            break;
        }
        default:
            break;
    }
}

@end
