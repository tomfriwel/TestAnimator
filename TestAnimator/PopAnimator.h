//
//  PopAnimator.h
//  Mega
//
//  Created by tomfriwel on 14/12/2016.
//  Copyright © 2016 jue.so. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAnimator : NSObject <UIViewControllerAnimatedTransitioning>{
    CGFloat duration;
}

@property BOOL presenting;
@property CGRect originFrame;

@end
