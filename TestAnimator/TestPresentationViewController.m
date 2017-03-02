//
//  TestPresentationViewController.m
//  TestAnimator
//
//  Created by tomfriwel on 28/02/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "TestPresentationViewController.h"
#import "PresentVC.h"
#import "PresentationController.h"
#import "RightSwipeTransition.h"

@interface TestPresentationViewController () <UIViewControllerTransitioningDelegate>

@property id percentDrivenTransition;
@property id dismissDrivenTransition;
@property PresentVC *presentVC;
@property RightSwipeTransition *presentTransition;
@property RightSwipeTransition *dismissTransition;

@end

@implementation TestPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presentTransition = [[RightSwipeTransition alloc] initWithIsPresent:YES];
    self.dismissTransition = [[RightSwipeTransition alloc] initWithIsPresent:NO];
    
    [self createVC];
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:edgePanGesture];
}

-(void)createVC {
    self.presentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PresentVC"];//[[PresentVC alloc] init];
    self.presentVC.view.backgroundColor = [UIColor whiteColor];
    // 设置 动画样式
    self.presentVC.modalPresentationStyle = UIModalPresentationCustom;
    //presentVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 此对象要实现 UIViewControllerTransitioningDelegate 协议
    self.presentVC.transitioningDelegate = self;
    
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanDismissGesture:)];
//    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanDismissGesture:)];
//    edgePanGesture.edges = UIRectEdgeRight;
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.presentVC.view addGestureRecognizer:swipeGesture];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)presentView:(id)sender {
    [self presentViewController:self.presentVC animated:YES completion:nil];
}

-(void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGPoint point = [edgePan translationInView:self.view];
    CGFloat w = self.view.bounds.size.width;
    
    CGFloat progress = point.x / w ;
    
    NSLog(@"point:%@, %.2f, %.2f", NSStringFromCGPoint(point), w, progress);
    
    //    NSLog(@"%f", progress);
    
    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.presentTransition.isPercentDriven = YES;
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        //        [self.navigationController pushViewController:self.presentVC animated:YES];
        [self presentViewController:self.presentVC animated:YES completion:nil];
        //        self.navigationController?.popViewControllerAnimated(true)
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        } else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
        self.presentTransition.isPercentDriven = NO;
    }
}

-(void)edgePanDismissGesture:(UIPanGestureRecognizer *)edgePan {
    CGPoint point = [edgePan translationInView:self.view];
    CGFloat w = PRESENTATION_W;//self.view.bounds.size.width;
    CGPoint vel = [edgePan velocityInView:self.view];
    
    static BOOL perform = NO;
    if (vel.x < 0 && !perform) {
        perform = YES;
    }
    else {
    }
    
    CGFloat progress = -point.x / PRESENTATION_W;
    
    NSLog(@"point:%@, %.2f, %.2f", NSStringFromCGPoint(point), w, progress);
    
    //    NSLog(@"%f", progress);
    
    if (edgePan.state == UIGestureRecognizerStateBegan && perform) {
        self.dismissTransition.isPercentDriven = YES;
        self.dismissDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        //        [self.navigationController pushViewController:self.presentVC animated:YES];
        [self.presentVC dismissViewControllerAnimated:YES completion:nil];
        //        self.navigationController?.popViewControllerAnimated(true)
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.dismissDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        perform = NO;
        if (progress > 0.3) {
            [self.dismissDrivenTransition finishInteractiveTransition];
        } else {
            [self.dismissDrivenTransition cancelInteractiveTransition];
        }
        self.dismissDrivenTransition = nil;
        self.dismissTransition.isPercentDriven = NO;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[PresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentTransition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissTransition;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.percentDrivenTransition;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.dismissDrivenTransition;
}

@end
