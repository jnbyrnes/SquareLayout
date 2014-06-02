//
//  SquareLayoutSquare.m
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import "SquareLayoutSquare.h"

@implementation SquareLayoutSquare

static int currentId = 0;

@synthesize padding, spacing, borderThickness, root, borderColor, backgroundColor, subviewLayout, subviews, squareId;

- (id)initWithPadding:(int)itemPadding spacing:(int)itemSpacing borderThickness:(float)itemBorderThickness root:(BOOL)itemRoot borderColor:(UIColor *)itemBorderColor backgroundColor:(UIColor *)itemBackgroundColor subviewLayout:(NSString *)itemSubviewLayout subviews:(NSArray *)itemSubviews
{
    self =[super init];
    
    if (self) {
        padding = itemPadding;
        spacing = itemSpacing;
        borderThickness = itemBorderThickness;
        root = itemRoot;
        borderColor = itemBorderColor;
        backgroundColor = itemBackgroundColor;
        subviewLayout = itemSubviewLayout;
        subviews = itemSubviews;
        squareId = currentId;
        currentId++;
    }
    return self;
}

@end
