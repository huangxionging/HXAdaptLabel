//
//  HXAddLabelViewController.m
//  HXAdaptLabel
//
//  Created by huangxiong on 14/12/31.
//  Copyright (c) 2014年 New_Life. All rights reserved.
//

#import "HXAddLabelViewController.h"
#import "AdaptLabelModel.h"
#import "AppDelegate.h"

@interface HXAddLabelViewController ()<UITextFieldDelegate>

/**
 *  第一次创建
 */
@property (nonatomic, assign) BOOL isFirstCreate;

/**
 * 应用代理对象
 */
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation HXAddLabelViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeftButtonWithNormalImage: @"leftSlide1" andHighLightImage: @"leftSlide2"];
    [self setNavigationTitle: @"添加标签"];
    self.leftButton.showsTouchWhenHighlighted = YES;
    _isFirstCreate = YES;
    _appDelegate = [UIApplication sharedApplication].delegate;
    [self setInputContainer];
    [self setTextField];
    [self setAddButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark---设置输入容器
- (void) setInputContainer
{
    _inputContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    _inputContainer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview: _inputContainer];
}

#pragma mark---创建文本输入框
- (void) setTextField
{
    _textField = [[UITextField alloc] initWithFrame: CGRectMake(20, (_inputContainer.frame.size.height - 30) / 2, SCREEN_WIDTH - 40, 30)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderWidth = 0.5;
   // _textField.layer.cornerRadius = 3;
    _textField.layer.borderColor = [UIColor blackColor].CGColor;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    //_textField.font = [UIFont boldSystemFontOfSize: 12.0];
    [_inputContainer addSubview: _textField];
}

#pragma mark---发送按钮
- (void) setAddButton
{
    _addButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _addButton.frame = CGRectMake(0, 0, 50, 30);
//    [_addButton setBackgroundImage: [UIImage imageNamed: @"addButton"] forState: UIControlStateNormal];
    [_addButton setTitle: @"添加" forState: UIControlStateNormal];
    [_addButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_addButton setTitleColor: [UIColor lightGrayColor] forState: UIControlStateHighlighted];
    [_addButton addTarget: self action:@selector(addClick) forControlEvents: UIControlEventTouchUpInside];
    _addButton.layer.masksToBounds = YES;
    _addButton.layer.borderWidth = 0.5;
    _addButton.layer.borderColor = [UIColor blackColor].CGColor;
    _textField.rightView = _addButton;
    _textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void) addClick
{
    [_textField resignFirstResponder];
    [self insertAdaptLabelModelWithTitleName: _textField.text];
}

#pragma mark---左导航按钮事件
- (void) navigationBarLeftClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark---插入数据
- (void)insertAdaptLabelModelWithTitleName: (NSString *)titleName;
{
    // 过滤掉空格和换行符
    NSString *tempString = [titleName stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (tempString == nil || [tempString isEqualToString: @""] == YES)
    {
        return;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"AdaptLabelModel"];
    
    // 设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF.titleName == %@", titleName];
    request.predicate = predicate;
    
    NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest: request error: nil];
    
    if (array.count != 0)
    {
        // 根据系统版本来判断
        [self showMessage: @"标签重复了哦"];
        return;
    }
    
    AdaptLabelModel *model = [NSEntityDescription insertNewObjectForEntityForName: @"AdaptLabelModel" inManagedObjectContext: _appDelegate.managedObjectContext];
    
    [model setValue: titleName forKey: @"titleName"];
    
    CGSize size = CGSizeZero;
    
    if (IOS6)
    {
        // iOS7以下操作系统使用
        size = [titleName sizeWithFont: [UIFont systemFontOfSize: 13.0] constrainedToSize: CGSizeMake(MAX_LABEL_WIDTH, 20) lineBreakMode: NSLineBreakByWordWrapping];
    }
    else
    {
        // iOS7.0以上
        // 获取字符串的宽度
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary *attributeDict = @{NSFontAttributeName : [UIFont systemFontOfSize: 13.0], NSParagraphStyleAttributeName : paragraphStyle};
        size = [titleName boundingRectWithSize: CGSizeMake(MAX_LABEL_WIDTH, 20) options: NSStringDrawingUsesLineFragmentOrigin attributes: attributeDict context: nil].size;
    }
    
    // 设置宽度
    [model setValue: [NSNumber numberWithInteger: size.width] forKey: @"titleWidth"];
    
    [_appDelegate saveContext];
    [self showMessage: @"添加成功"];
    _textField.text = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:  @"AddLabel" object: nil userInfo: @{@"newLabel" : model}];
}

#pragma mark---UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
