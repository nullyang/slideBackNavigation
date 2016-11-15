//
//  MYNavigationController.m
//  手势移除控制器
//
//  Created by 田阳阳 on 16/1/17.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import "MYNavigationController.h"
@interface MYNavigationController()
@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong)UIView *lastVcView;
@property (nonatomic ,strong)NSMutableArray *historyViewList;
@end
@implementation MYNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.lastVcXScale = 0.6;
    //屏蔽原生的返回事件
    self.interactivePopGestureRecognizer.enabled = NO;
    //触发滑动距离
    self.trigDistance = self.trigDistance ? self.trigDistance :200;
    //手势
    UIPanGestureRecognizer *panGes =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesAction:)];
    [self.view addGestureRecognizer:panGes];
}

//push的时候，截图
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIView *view = [self.view snapshotViewAfterScreenUpdates:YES];
    [self.historyViewList addObject:view];
    [super pushViewController:viewController animated:animated];
}

//pop的时候移除最后一个控制器的截图
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self.historyViewList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - 手势事件
- (void)panGesAction:(UIPanGestureRecognizer *)panGesture{
    if (!(self.childViewControllers.count > 1)) {
        return;
    }
    CGFloat tx = [panGesture translationInView:self.view].x;
    //手指快速滑动
    if (tx<=0 && (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateChanged)) {
        [self resumeWithAnimated:NO];
        return;
    }
    //只能右滑
    if (tx<=0) {
        if (panGesture.state != UIGestureRecognizerStateChanged) {
            return;
        }
    }
    self.view.transform = CGAffineTransformMakeTranslation(tx, 0);
    
    UIView *superView = [self superView];
    //蒙版
    self.bgView.frame = superView.bounds;
    self.bgView.alpha = 0.5;
    if (![superView.subviews containsObject:self.bgView]) {
        [superView insertSubview:self.bgView belowSubview:self.view];
    }
    //上个控制器截图
    CGRect frame = superView.bounds;
    CGFloat lastVcX = (self.view.frame.origin.x - self.view.bounds.size.width)*self.lastVcXScale;
    frame.origin.x = lastVcX;
    self.lastVcView.frame = frame;
    if (![superView.subviews containsObject:self.lastVcView]) {
        [superView insertSubview:self.lastVcView belowSubview:self.bgView];
    }
    NSLog(@"frame=%@",NSStringFromCGRect(self.lastVcView.frame));
    //结束滑动
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled ) {
        [self judgeShouldPop];
    }
    NSLog(@"tx=%f",tx);
}

#pragma 手势结束后的处理

- (void)judgeShouldPop{
    CGFloat tx = self.view.frame.origin.x;
    if (tx >= self.trigDistance) {
        [self popViewController];
    }else {
        [self resumeWithAnimated:YES];
    }
}

- (void)popViewController{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        self.lastVcView.frame = [self superView].bounds;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self popViewControllerAnimated:NO];
        self.view.transform = CGAffineTransformIdentity;
        [self removeLastVcView];
    }];
}

- (void)resumeWithAnimated:(BOOL)animated{
    if (!animated) {
        self.view.transform = CGAffineTransformIdentity;
        [self removeLastVcView];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            [self removeLastVcView];
        }];
    }
}

- (void)removeLastVcView{
    [self.lastVcView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (NSMutableArray *)historyViewList{
    if (_historyViewList) {
        return _historyViewList;
    }
    _historyViewList = @[].mutableCopy;
    return _historyViewList;
}

- (UIView *)lastVcView{
    return self.historyViewList.lastObject;
}

- (UIView *)superView{
    if (self.view.superview) {
        return self.view.superview;
    }else {
        return [UIApplication sharedApplication].windows.lastObject;
    }
}

- (UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    return _bgView;
}
@end
