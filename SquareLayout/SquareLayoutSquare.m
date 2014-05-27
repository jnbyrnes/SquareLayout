//
//  SquareLayoutSquare.m
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import "SquareLayoutSquare.h"

@implementation SquareLayoutSquare

@synthesize padding, spacing, borderThickness, borderColor, backgroundColor, subviewLayout, subviews;

- (id)initWithPadding:(int)itemPadding spacing:(int)itemSpacing borderThickness:(float)itemBorderThickness borderColor:(UIColor *)itemBorderColor backgroundColor:(UIColor *)itemBackgroundColor subviewLayout:(NSString *)itemSubviewLayout subviews:(NSArray *)itemSubviews
{
    self =[super init];
    
    if (self) {
        padding = itemPadding;
        spacing = itemSpacing;
        borderThickness = itemBorderThickness;
        borderColor = itemBorderColor;
        backgroundColor = itemBackgroundColor;
        subviewLayout = itemSubviewLayout;
        subviews = itemSubviews;
    }
    return self;
}

@end
