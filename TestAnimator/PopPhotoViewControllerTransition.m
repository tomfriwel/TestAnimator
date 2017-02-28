//
//  PopPhotoViewControllerTransition.m
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import "PopPhotoViewControllerTransition.h"
#import "UIView+Snapshot.h"

@implementation PopPhotoViewControllerTransition

-(instancetype)init{
    self = [super init];
    
    self.presenting = YES;
    
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
        UIViewController *fromViewController =  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toViewController];
        UIView *containerView = transitionContext.containerView;
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height);
        
        [containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            fromViewController.view.alpha = 0.5;
            toViewController.view.frame = finalFrameForVC;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            fromViewController.view.alpha = 1.0;
        }];
    } else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toViewController];
        UIView *containerView = transitionContext.containerView;
        
        toViewController.view.frame = finalFrameForVC;
        toViewController.view.alpha = 0.5;
        [containerView addSubview: toViewController.view];
        [containerView sendSubviewToBack:toViewController.view];
        
        UIView *snapshotView = [fromViewController.view snapshotView];
        
        snapshotView.frame = fromViewController.view.frame;
        [containerView addSubview: snapshotView];
        
        [fromViewController.view removeFromSuperview];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            snapshotView.frame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width / 2, fromViewController.view.frame.size.height / 2);
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (snapshotView) {
                
                [snapshotView removeFromSuperview];
            }
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
