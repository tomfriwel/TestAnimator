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

@interface TestPresentationViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation TestPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)presentView:(id)sender {
    PresentVC *presentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PresentVC"];//[[PresentVC alloc] init];
    presentVC.view.backgroundColor = [UIColor grayColor];
    // 设置 动画样式
    presentVC.modalPresentationStyle = UIModalPresentationCustom;
    //presentVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 此对象要实现 UIViewControllerTransitioningDelegate 协议
    presentVC.transitioningDelegate = self;
    [self presentViewController:presentVC animated:YES completion:nil];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[PresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
