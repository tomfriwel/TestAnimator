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
    
    [_visualView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    
    [self.containerView addSubview:_visualView];
    
    // Get the transition coordinator for the presentation so we can
    // fade in the dimmingView alongside the presentation animation.
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.visualView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.visualView.alpha = 0.5f;
    } completion:NULL];
}

-(void)presentationTransitionDidEnd:(BOOL)completed {
    // 如果呈现没有完成，那就移除背景 View
    if (!completed) {
        [_visualView removeFromSuperview];
    }
}

-(void)dismissalTransitionWillBegin {
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.visualView.alpha = 0.f;
    } completion:NULL];
    
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [_visualView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView{
    
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    
//    self.presentedView.frame = CGRectMake(0, windowH - 300, windowW, 300);
    self.presentedView.frame = CGRectMake(0, 0, PRESENTATION_W, windowH);
    
    return self.presentedView.frame;
}

#pragma mark - action

- (IBAction)dimmingViewTapped:(UITapGestureRecognizer*)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
