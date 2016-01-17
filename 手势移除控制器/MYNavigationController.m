//
//  MYNavigationController.m
//  手势移除控制器
//
//  Created by 田阳阳 on 16/1/17.
//  Copyright © 2016年 田阳阳. All rights reserved.
//
#define lastVcViewX -[UIScreen mainScreen].bounds.size.width * 0.6
#import "MYNavigationController.h"
@interface MYNavigationController()
@property (nonatomic ,strong)UIImageView *lastVcView;
@property (nonatomic ,strong)UIView *cover;
@end
@implementation MYNavigationController
{
    NSMutableArray *images;
}

#pragma mark - subviews
- (UIImageView *)lastVcView{
    if (_lastVcView) {
        return _lastVcView;
    }
    _lastVcView = [[UIImageView alloc]init];
    return _lastVcView;
}

- (UIView *)cover{
    if (_cover) {
        return _cover;
    }
    _cover = [[UIView alloc]init];
    _cover.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    return _cover;
}

#pragma mark - uiLife
- (void)viewDidLoad{
    [super viewDidLoad];
    images = [NSMutableArray array];
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *panGes =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesAction:)];
    [self.view addGestureRecognizer:panGes];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self createScreenShot];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [images removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - 截屏
- (void)createScreenShot{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [images addObject:image];
}

#pragma mark - 手势事件
- (void)panGesAction:(UIPanGestureRecognizer *)gester{
    if (self.childViewControllers.count<=1) {
        return;
    }
    CGFloat tx = [gester translationInView:self.view].x;
    if (tx<0) {
        return;
    }
    self.view.transform = CGAffineTransformMakeTranslation(tx, 0);
    [self addLastVcView];
    [self addCoverView];
    if (gester.state == UIGestureRecognizerStateEnded || gester.state == UIGestureRecognizerStateCancelled) {
        [self handlePop];
    }
}

- (void)addLastVcView{
    self.lastVcView.image = images.lastObject;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect frame = keyWindow.bounds;
    CGFloat lastVcMove = lastVcViewX + self.view.frame.origin.x * 0.6;
    frame.origin.x = lastVcMove;
    self.lastVcView.frame = frame;
    [keyWindow insertSubview:self.lastVcView belowSubview:self.view];
}

- (void)addCoverView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.cover.frame = keyWindow.frame;
    [keyWindow insertSubview:self.cover belowSubview:self.view];
    NSLog(@"%zd",keyWindow.subviews.count);
}

#pragma 手势结束后的处理
- (void)handlePop{
    CGFloat tx = self.view.frame.origin.x;
    if (tx >= 100) {
        [self customPop];
    }else {
        [self indentity];
    }
}

- (void)customPop{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        self.lastVcView.frame = [UIScreen mainScreen].bounds;
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        [self popViewControllerAnimated:NO];
        self.view.transform = CGAffineTransformIdentity;
        [self.lastVcView removeFromSuperview];
        [self.cover removeFromSuperview];
    }];
}

- (void)indentity{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
@end
