//
//  CustomNavigationAnimationController.m
//  TestAnimator
//
//  Created by tomfriwel on 29/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import "CustomNavigationAnimationController.h"
#import "PushedViewController.h"

@implementation CustomNavigationAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    CGFloat direction = self.reverse ? -1 : 1;
//    CGFloat cons = -0.005;
    
//    toView.layer.anchorPoint =  CGPointMake(direction==1 ? 0 : 1, 0.5);
//    fromView.layer.anchorPoint = CGPointMake(direction==1 ? 1 : 0, 0.5);
    
    CATransform3D viewFromTransform = CATransform3DMakeTranslation(0, 0, 0);
    //CATransform3DMakeRotation(direction * (M_PI_2), 0.0, 1.0, 0.0);
    
    CATransform3D viewToTransform = CATransform3DMakeTranslation(0, direction * containerView.frame.size.height, 0);//CATransform3DMakeRotation(-direction * (M_PI_2), 0.0, 1.0, 0.0);

    
//    viewFromTransform.m34 = cons;
//    viewToTransform.m34 = cons;
    
    containerView.transform = CGAffineTransformMakeTranslation(0, 0);
    
    toView.layer.transform = viewToTransform;
    [containerView addSubview: toView];
//    if ([toViewController isKindOfClass:[PushedViewController class]]) {
//        PushedViewController *vc = (PushedViewController *)toViewController;
//        [vc.textField becomeFirstResponder];
//    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        containerView.transform = CGAffineTransformMakeTranslation(0, -direction * containerView.frame.size.height);
        fromView.layer.transform = viewFromTransform;
        toView.layer.transform = CATransform3DMakeTranslation(0, direction * containerView.frame.size.height, 0);//CATransform3DIdentity;
        
        
        
    } completion:^(BOOL finished) {
        containerView.transform =  CGAffineTransformIdentity;
        fromView.layer.transform = CATransform3DIdentity;
        toView.layer.transform = CATransform3DIdentity;
//        fromView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        if (transitionContext.transitionWasCancelled) {
            [toView removeFromSuperview];
        } else {
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
    }];
}

@end
