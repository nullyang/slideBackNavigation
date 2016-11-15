//
//  MYNavigationController.h
//  手势移除控制器
//
//  Created by 田阳阳 on 16/1/17.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYNavigationController : UINavigationController
@property (nonatomic ,assign)CGFloat trigDistance; //触发距离
@property (nonatomic ,assign)CGFloat lastVcXScale;//上一个控制器截图X值<0的部分占比
@end
