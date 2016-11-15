//
//  TYImageBasicController.m
//  手势移除控制器
//
//  Created by Null on 16/11/11.
//  Copyright © 2016年 田阳阳. All rights reserved.
//

#import "TYImageBasicController.h"
#import <math.h>
@interface TYImageBasicController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TYImageBasicController{
    CGSize _imageSize;
    CGFloat _maxScale;
    CGFloat _minScale;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configureSubview];
    
    [self configureImage];
}

- (void)configureSubview{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}

- (void)configureImage{
    _minScale = 1.0;
    CGFloat widthScale = _imageSize.width/self.view.bounds.size.width;
    CGFloat heightScale = _imageSize.height/self.view.bounds.size.height;
    CGRect imageFrame ;
    CGSize mainSize = self.scrollView.bounds.size;
    if (widthScale <= heightScale) {
        imageFrame = CGRectMake(0.5*(mainSize.width - _imageSize.width / heightScale), 0, _imageSize.width / heightScale, mainSize.height);
        _maxScale = self.view.bounds.size.width/imageFrame.size.width;
    }else {
        imageFrame = CGRectMake(0, 0.5*(mainSize.height - _imageSize.height / widthScale), mainSize.width, _imageSize.height / widthScale);
        _maxScale = self.view.bounds.size.height/imageFrame.size.height;
    }
    _maxScale = 5;
    self.imageView.frame = imageFrame;
    self.scrollView.minimumZoomScale = _minScale;
    self.scrollView.maximumZoomScale = _maxScale;
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture{
    CGFloat scale = self.scrollView.zoomScale == 1.0 ? _maxScale : 1.0;
    [UIView animateWithDuration:0.5 animations:^{
       self.scrollView.zoomScale = scale;
    }];
}

#pragma mark - scrollDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"size=%@",NSStringFromCGSize(scrollView.contentSize));
}

#pragma mark - subViews

- (UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bouncesZoom = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    return _scrollView;
}

- (UIImageView *)imageView{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    _scrollView.contentSize = self.imageView.frame.size;
    _imageView.image = [self performSelector:@selector(image)];
    _imageSize = _imageView.image.size;
    return _imageView;
}


@end
