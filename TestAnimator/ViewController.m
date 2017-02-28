//
//  ViewController.m
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import "ViewController.h"
#import "PopViewController.h"

#import "PopPhotoViewControllerTransition.h"
#import "CustomInteractionController.h"
#import "CustomNavigationAnimationController.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, CustomInteractionControllerDelegate>

//@property PopPhotoViewControllerTransition *popTransition;
@property CustomInteractionController *interaction;
@property CustomNavigationAnimationController *navAnimation;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property BOOL transitionInProgress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.popTransition = [[PopPhotoViewControllerTransition alloc] init];
    self.interaction = [[CustomInteractionController alloc] init];
    self.interaction.interactionDelegate = self;
    
    self.navAnimation = [[CustomNavigationAnimationController alloc] init];
    self.navigationController.delegate = self;
    [self.interaction attachToViewController:self forEdge:UIRectEdgeRight];
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
}

- (IBAction)testAction:(id)sender {
    PopViewController *vc = [[PopViewController alloc] init];
    
    [vc setTransitioningDelegate:self];
//    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
}

#pragma mark - CustomInteractionControllerDelegate

-(void)beginInteractionForEdge:(UIRectEdge)edge {
    switch (edge) {
        case UIRectEdgeRight:{
            PopViewController *vc = [[PopViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"Bttom");
            break;
        }
        case UIRectEdgeLeft:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
            
        default:
            break;
    }
}

-(void)endInteraction {
}

#pragma mark - UIViewControllerTransitioningDelegate

//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
//    
////    CGRect rectOfCellInTableView = self.selectedCellRect;
////    CGRect rectOfCellInSuperview = [self.tableView convertRect:rectOfCellInTableView toView:[self.tableView superview]];
//    
////    CGRect rectOfCellInSuperview = self.button.frame;
////    
////    self.transition.originFrame = rectOfCellInSuperview;
////    self.transition.presenting = YES;
//    
////    return self.transition;
//    self.popTransition.presenting = YES;
//    return self.popTransition;
//}
//
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
////    self.transition.presenting = NO;
////    return self.transition;
//    
//    self.popTransition.presenting = NO;
//    return self.popTransition;
//}

#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        [self.interaction attachToViewController:toVC forEdge:UIRectEdgeLeft];
    }
    self.navAnimation.reverse = operation == UINavigationControllerOperationPop;
    return self.navAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interaction.transitionInProgress ? self.interaction : nil;
}


//-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
//    [self.interaction attachToViewController:self.navigationController];
//    return self.interaction;
//}
//
//-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return self.interaction;
//}

@end
