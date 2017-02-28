//
//  PhotosPopTransitionManager.h
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosPopTransitionManager : UIPercentDrivenInteractiveTransition< UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic) UIViewController *sourceViewController;

@end
