//
//  AdaptRowlModel.m
//  HXAdaptLabel
//
//  Created by huangxiong on 15/1/9.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import "AdaptRowlModel.h"

@implementation AdaptRowlModel


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _adaptLabels = [[NSMutableArray alloc] init];
        _totalWidth = 0;
    }
    return self;
}

@end
