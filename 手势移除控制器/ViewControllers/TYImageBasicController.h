//
//  TYImageBasicController.h
//  手势移除控制器
//
//  Created by Null on 16/11/11.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSourceProtocol <NSObject>

@optional
- (UIImage *)image;
@end

@interface TYImageBasicController : UIViewController

@end
