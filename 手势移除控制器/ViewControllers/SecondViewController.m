//
//  SecondViewController.m
//  手势移除控制器
//
//  Created by 田阳阳 on 16/1/17.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<ImageSourceProtocol>

@end
@implementation SecondViewController

- (UIImage *)image{
    return [UIImage imageNamed:@"155.jpg"];
}
@end
