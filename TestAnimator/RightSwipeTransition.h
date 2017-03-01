//
//  RightSwipeTransition.h
//  TestAnimator
//
//  Created by tomfriwel on 28/02/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightSwipeTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPercentDriven;

-(instancetype)initWithIsPresent:(BOOL)isPresent;

@end
