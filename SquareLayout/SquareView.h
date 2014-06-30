//
//  SquareView.h
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 6/30/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareLayoutSquare.h"

@protocol SquareViewDelegate <NSObject>
- (void)removeSquare:(int)squareId;
@end

@interface SquareView : UIView <UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic, strong) SquareLayoutSquare *square;
@property (nonatomic, weak) id <SquareViewDelegate> delegate;

- (void)customizeView:(SquareLayoutSquare *)square;

@end
