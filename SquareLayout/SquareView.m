//
//  SquareView.m
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 6/30/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import "SquareView.h"

@implementation SquareView

@synthesize square, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [self addGestureRecognizer:rightSwipeGestureRecognizer];
        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [leftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:leftSwipeGestureRecognizer];
        UISwipeGestureRecognizer *upSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUp:)];
        [upSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:upSwipeGestureRecognizer];
        UISwipeGestureRecognizer *downSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeDown:)];
        [downSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
        [self addGestureRecognizer:downSwipeGestureRecognizer];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)customizeView:(SquareLayoutSquare *)itemSquare
{
    [self setBackgroundColor:[itemSquare backgroundColor]];
    [[self layer] setBorderColor:[[itemSquare borderColor] CGColor]];
    [[self layer] setBorderWidth:[itemSquare borderThickness]];
    [self setSquare:itemSquare];
}

- (void)didSwipeRight:(UISwipeGestureRecognizer *)gr
{
    NSLog(@"Did Swipe Right!!!!");
    [self didSwipe:gr];
}

- (void)didSwipeLeft:(UISwipeGestureRecognizer *)gr
{
    NSLog(@"Did Swipe Left!!!!");
    [self didSwipe:gr];
}

- (void)didSwipeUp:(UISwipeGestureRecognizer *)gr
{
    NSLog(@"Did Swipe Up!!!!");
    [self didSwipe:gr];
}

- (void)didSwipeDown:(UISwipeGestureRecognizer *)gr
{
    NSLog(@"Did Swipe Down!!!!");
    [self didSwipe:gr];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)gr
{
    UIView *currentView = [gr view];
    if (currentView) {
        [delegate removeSquare:[square squareId]];
    }
}

- (void)didTap:(UITapGestureRecognizer *)gr
{
    UIView *currentView = [gr view];
    if (currentView) {
        [delegate addChildrenSquares:[square squareId]];
    }
}

@end
