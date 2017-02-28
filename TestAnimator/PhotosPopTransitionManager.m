//
//  PhotosPopTransitionManager.m
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import "PhotosPopTransitionManager.h"
#import "UIView+Snapshot.h"

@interface PhotosPopTransitionManager()

@property (nonatomic) UIScreenEdgePanGestureRecognizer *enterPanGesture;

@end

@implementation PhotosPopTransitionManager

-(instancetype)init{
    self = [super init];
    
    self.presenting = YES;
    
    return self;
}

-(void)setSourceViewController:(UIViewController *)sourceViewController {
    self.enterPanGesture = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [self.enterPanGesture addTarget:self action:@selector(handleOnstagePan:)];
    self.enterPanGesture.edges = UIRectEdgeLeft;
    [self.sourceViewController.view addGestureRecognizer:self.enterPanGesture];
}

-(void)handleOnstagePan:(UIScreenEdgePanGestureRecognizer *)pan{
    // how much distance have we panned in reference to the parent view?
    CGPoint translation = [pan translationInView:pan.view];
    
    // do some math to translate this to a percentage based value
    CGFloat d =  translation.x / CGRectGetWidth(pan.view.bounds) * 0.5;
    
    // now lets deal with different states that the gesture recognizer sends
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:
            // set our interactive flag to true
            self.interactive = YES;
            
            // trigger the start of the transition
            [self.sourceViewController performSegueWithIdentifier:@"presentMenu" sender:self];
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
            // update progress of the transition
            [self updateInteractiveTransition:d];
            break;
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = NO;
            [self finishInteractiveTransition];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
        UIViewController *fromViewController =  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toViewController];
        UIView *containerView = transitionContext.containerView;
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, -bounds.size.height);
        
        [containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
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
