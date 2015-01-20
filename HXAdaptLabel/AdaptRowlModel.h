//
//  AdaptRowlModel.h
//  HXAdaptLabel
//
//  Created by huangxiong on 15/1/9.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdaptRowlModel : NSObject

/**
 *  存放数据的数组
 */
@property (nonatomic, strong) NSMutableArray *adaptLabels;

/**
 *  一行的总宽度
 */
@property (nonatomic, assign) NSInteger totalWidth;

- (instancetype)init;

@end
