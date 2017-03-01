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
@property PresentVC *presentVC;
@property RightSwipeTransition *presentTransition;

@end

@implementation TestPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presentTransition = [[RightSwipeTransition alloc] initWithIsPresent:YES];
    
    [self createVC];
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:edgePanGesture];
}

-(void)createVC {
    
    self.presentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PresentVC"];//[[PresentVC alloc] init];
    self.presentVC.view.backgroundColor = [UIColor grayColor];
    // 设置 动画样式
    self.presentVC.modalPresentationStyle = UIModalPresentationCustom;
    //presentVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 此对象要实现 UIViewControllerTransitioningDelegate 协议
    self.presentVC.transitioningDelegate = self;
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

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[PresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentTransition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    RightSwipeTransition *present = [[RightSwipeTransition alloc] initWithIsPresent:NO];
    return present;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.percentDrivenTransition;
}

@end
