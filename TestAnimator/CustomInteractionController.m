//
//  CustomInteractionController.m
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import "CustomInteractionController.h"

@implementation CustomInteractionController

-(instancetype)init {
    self = [super init];
    
    self.shouldCompleteTransition = NO;
    self.transitionInProgress = NO;
    
    return self;
}

-(void)attachToViewController:(UIViewController *)viewController forEdge:(UIRectEdge)edge {
    self.navigationController = viewController.navigationController;
    [self setupGestureRecognizer:viewController.view forEdge:(UIRectEdge)edge];
}

-(CGFloat)completionSeed {
    return 1-self.percentComplete;
}

-(void)setupGestureRecognizer:(UIView *)view forEdge:(UIRectEdge)edge {
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGesture:)];
    edgeGesture.edges = edge;
    [view addGestureRecognizer:edgeGesture];
    
//    [view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
}

-(void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    CGPoint viewTranslation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.transitionInProgress = YES;
            
            
            [self.interactionDelegate beginInteractionForEdge:gestureRecognizer.edges];
            //            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            NSLog(@"%f", viewTranslation.x);
            CGFloat cons = fminf(fmaxf((fabs(viewTranslation.x) / 300.0), 0.0), 1.0);
            self.shouldCompleteTransition = cons > 0.5;
            [self updateInteractiveTransition:cons];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.transitionInProgress = NO;
            if (!self.shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            [self.interactionDelegate endInteraction];
            break;
        }
        default:
            break;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint viewTranslation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.transitionInProgress = YES;
            
//            [self.interactionDelegate beginInteractionForEdge:gestureRecognizer.ed];
//            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            NSLog(@"%f", viewTranslation.y);
            CGFloat cons = fminf(fmaxf((viewTranslation.y / 300.0), 0.0), 1.0);
            self.shouldCompleteTransition = cons > 0.5;
            [self updateInteractiveTransition:cons];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.transitionInProgress = NO;
            if (!self.shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            [self.interactionDelegate endInteraction];
            break;
        }
        default:
            break;
    }
}

@end
