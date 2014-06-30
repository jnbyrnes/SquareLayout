//
//  SquareLayoutViewController.h
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareView.h"

@class SquareLayoutSquare;

@interface SquareLayoutViewController : UIViewController <SquareViewDelegate>
{
    SquareLayoutSquare *rootSquare;
}

@end
