//
//  PresentationController.m
//  TestAnimator
//
//  Created by tomfriwel on 28/02/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "PresentationController.h"

@interface PresentationController ()

@property (nonatomic,strong) UIVisualEffectView *visualView;

@end

@implementation PresentationController

-(void)presentationTransitionWillBegin {
    // 使用UIVisualEffectView实现模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _visualView.frame = self.containerView.bounds;
    _visualView.alpha = 0.4;
    _visualView.backgroundColor = [UIColor blackColor];
    
    [self.containerView addSubview:_visualView];
}

-(void)presentationTransitionDidEnd:(BOOL)completed {
    // 如果呈现没有完成，那就移除背景 View
    if (!completed) {
        [_visualView removeFromSuperview];
    }
}

-(void)dismissalTransitionWillBegin {
    _visualView.alpha = 0.0;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [_visualView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView{
    
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    
    self.presentedView.frame = CGRectMake(0, windowH - 300, windowW, 300);
    
    return self.presentedView.frame;
}

@end
