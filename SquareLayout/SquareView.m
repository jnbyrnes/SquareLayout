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
        // Add Swipe Gesture Recognizers
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
        // Add Tap Gesture Recognizers
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        // Add Long Press Gesture Recognizers
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        [self addGestureRecognizer:longPressGestureRecognizer];
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
    [delegate removeSquare:[square squareId]];
}

- (void)didTap:(UITapGestureRecognizer *)gr
{
    NSLog(@"Did Tap!!!!");
    [delegate addChildrenSquares:[square squareId]];
}

- (void)didLongPress:(UILongPressGestureRecognizer *)gr
{
    NSLog(@"Did Long Press!!!!");
    NSLog(@"%d", gr.state);
    if (gr.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        CGPoint location = [gr locationInView:[gr view]];
        [delegate moveSquare:[square squareId] withEndingPoint:location];
    } else if (gr.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        UIView *currentView = [gr view];
        [currentView removeFromSuperview];
    } else if (gr.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"UIGestureRecognizerStateRecognized");
    } else if (gr.state == UIGestureRecognizerStateFailed) {
        NSLog(@"UIGestureRecognizerStateFailed");
    } else if (gr.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"UIGestureRecognizerStateCancelled");
        CGPoint location = [gr locationInView:[gr view]];
        [delegate moveSquare:[square squareId] withEndingPoint:location];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
}

@end
