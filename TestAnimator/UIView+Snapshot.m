//
//  UIView+Snapshot.m
//  TestAnimator
//
//  Created by tomfriwel on 28/12/2016.
//  Copyright © 2016 tomfriwel. All rights reserved.
//

#import "UIView+Snapshot.h"

#ifndef nob_defer_h
#define nob_defer_h

// some helper declarations
#define _nob_macro_concat(a, b) a##b
#define nob_macro_concat(a, b) _nob_macro_concat(a, b)
typedef void(^nob_defer_block_t)();
NS_INLINE void nob_deferFunc(__strong nob_defer_block_t *blockRef)
{
    nob_defer_block_t actualBlock = *blockRef;
    actualBlock();
}

// the core macro
#define nob_defer(deferBlock) \
__strong nob_defer_block_t nob_macro_concat(__nob_stack_defer_block_, __LINE__) __attribute__((cleanup(nob_deferFunc), unused)) = deferBlock

#endif /* nob_defer_h */

@implementation UIView (Snapshot)

-(UIView *)snapshotView {
    UIImage *image = [self snapshotImage];
    
    return [[UIImageView alloc] initWithImage:image];
}

-(UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, self.contentScaleFactor);
    nob_defer(^{
        UIGraphicsEndImageContext();
    });
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:false];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
