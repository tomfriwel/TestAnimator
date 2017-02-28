//
//  PopAnimator.m
//  Mega
//
//  Created by tomfriwel on 14/12/2016.
//  Copyright © 2016 jue.so. All rights reserved.
//

#import "PopAnimator.h"

@implementation PopAnimator

-(instancetype)init{
    self = [super init];
    
    duration = 0.4;
    self.presenting = YES;
    self.originFrame = CGRectZero;
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    id containerView = transitionContext.containerView;
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *fromView = self.presenting ? toView : [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGRect initialFrame = self.presenting ? self.originFrame : fromView.frame;
    CGRect finalFrame = self.presenting ? fromView.frame : self.originFrame;
    
    CGFloat xScaleFactor = self.presenting ?
    initialFrame.size.width / finalFrame.size.width :
    finalFrame.size.width / initialFrame.size.width;
    
    CGFloat yScaleFactor = self.presenting ?
    initialFrame.size.height / finalFrame.size.height :
    finalFrame.size.height / initialFrame.size.height;
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);
    
    if(self.presenting) {
        fromView.transform = scaleTransform;
        fromView.center =  CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));
        fromView.clipsToBounds = YES;
    }
    
//    CABasicAnimation *round = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//    round.fromValue = [NSString stringWithFormat:@"%f", self.presenting ? 20.0/xScaleFactor : 0.0];
//    round.toValue = [NSString stringWithFormat:@"%f", self.presenting ? 0.0 : 20.0/xScaleFactor];
//    round.duration = duration / 2;
//    [fromView.layer addAnimation:round forKey:nil];
//    
//    fromView.layer.cornerRadius = self.presenting ? 0.0 : 20.0/xScaleFactor;
    
    [containerView addSubview:toView];
    [containerView bringSubviewToFront:fromView];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        fromView.transform = self.presenting ?
        CGAffineTransformIdentity : scaleTransform;
        
        fromView.center = CGPointMake(CGRectGetMidX(finalFrame), CGRectGetMidY(finalFrame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
