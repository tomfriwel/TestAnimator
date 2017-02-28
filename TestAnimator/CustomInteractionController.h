//
//  CustomInteractionController.h
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomInteractionControllerDelegate <NSObject>

-(void)beginInteractionForEdge:(UIRectEdge)edge;
-(void)endInteraction;

@end

@interface CustomInteractionController : UIPercentDrivenInteractiveTransition
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) id <CustomInteractionControllerDelegate> interactionDelegate;

@property (nonatomic, assign) BOOL shouldCompleteTransition;
@property (nonatomic, assign) BOOL transitionInProgress;

@property (nonatomic, assign) CGFloat completionSeed;

-(void)attachToViewController:(UIViewController *)viewController forEdge:(UIRectEdge)edge;

@end
