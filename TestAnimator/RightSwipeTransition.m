//
//  RightSwipeTransition.m
//  TestAnimator
//
//  Created by tomfriwel on 28/02/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "RightSwipeTransition.h"
#import "PresentationController.h"

@interface RightSwipeTransition()

@property (nonatomic, assign) BOOL isPresent;

@end

@implementation RightSwipeTransition

-(instancetype)initWithIsPresent:(BOOL)isPresent {
    self = [super init];
    
    self.isPercentDriven = NO;
    self.isPresent = isPresent;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresent) {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        __strong UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        if (!fromView) {
            fromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        }
        
        fromView.tag = 100;
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *containerView = [transitionContext containerView];
        containerView.backgroundColor = [UIColor blackColor];
        //设定presented view 一开始的位置，在屏幕下方
        CGRect finalframe = [transitionContext finalFrameForViewController:toVC];
        CGRect startframe = CGRectOffset(finalframe, -finalframe.size.width, 0);
        toView.frame = startframe;
        
        CGRect fromFinalFrame = CGRectOffset(fromView.frame, PRESENTATION_W, 0);

        [containerView insertSubview:fromView atIndex:0];
        [containerView addSubview:toView];
        if (!self.isPercentDriven) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                //secondviewcontroller 滑上来
                toView.frame = finalframe;
                fromView.frame = fromFinalFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
            }];
        }
        else {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toView.frame = finalframe;
                fromView.frame = fromFinalFrame;
//                fromVC.view.transform = fromViewTransform;
            } completion:^(BOOL finished) {
//                fromVC.view = fromView;
                [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
            }];
        }
    }
    else{
        UIView *containerView = [transitionContext containerView];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        if (!fromView) {
            fromView = fromVC.view;
        }
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        if (!toView) {
            toView = [containerView viewWithTag:100];
        }
        
        
        //设定presented view 一开始的位置，在屏幕下方
        CGRect finalframe = [transitionContext finalFrameForViewController:fromVC];
        finalframe = CGRectOffset(finalframe, -finalframe.size.width, 0);
        
        CGRect toFinalFrame = CGRectOffset(toView.frame, -PRESENTATION_W, 0);
        
//        [containerView addSubview:fromView];
        if (!self.isPercentDriven) {
            
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            //secondviewcontroller 滑上来
            fromView.frame = finalframe;
            toView.frame = toFinalFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
        }];
        }
        else {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                fromView.frame = finalframe;
                toView.frame = toFinalFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
            }];
        }
    }
}

@end
