//
//  FirstViewController.m
//  手势移除控制器
//
//  Created by 田阳阳 on 16/1/17.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<ImageSourceProtocol>

@end

@implementation FirstViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (UIImage *)image{
    return [UIImage imageNamed:@"064.jpg"];
}
@end
