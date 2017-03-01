//
//  RightSwipeTransition.m
//  TestAnimator
//
//  Created by tomfriwel on 28/02/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "RightSwipeTransition.h"

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
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *containerView = [transitionContext containerView];
        
        //设定presented view 一开始的位置，在屏幕下方
        CGRect finalframe = [transitionContext finalFrameForViewController:toVC];
        CGRect startframe = CGRectOffset(finalframe, -finalframe.size.width, 0);
        toView.frame = startframe;
        
        [containerView addSubview:toView];
        if (!self.isPercentDriven) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                //secondviewcontroller 滑上来
                toView.frame = finalframe;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
            }];
        }
        else {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toView.frame = finalframe;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
            }];
        }
    }
    else{
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *containerView = [transitionContext containerView];
        
        //设定presented view 一开始的位置，在屏幕下方
        CGRect finalframe = [transitionContext finalFrameForViewController:fromVC];
        finalframe = CGRectOffset(finalframe, -finalframe.size.width, 0);
        
        [containerView addSubview:fromView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            //secondviewcontroller 滑上来
            fromView.frame = finalframe;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
