//
//  MYNavigationController.h
//  手势移除控制器
//
//  Created by 田阳阳 on 16/1/17.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYNavigationController : UINavigationController
@property (nonatomic ,assign)CGFloat maxBounceDistance; //最大回弹距离
@property (nonatomic ,assign)CGFloat lastVcX;//上一个视图截图的x值
@end
