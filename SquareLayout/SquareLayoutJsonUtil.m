//
//  SquareLayoutJsonUtil.m
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import "SquareLayoutJsonUtil.h"
#import "SquareLayoutSquare.h"

static int const PaddingDefault = 0;
static int const SpacingDefault = 0;
static float const BorderThicknessDefault = 0;
static NSString * const SubviewLayoutDefault = @"horizontal";

static NSString * const RootKey = @"root-view";
static NSString * const PaddingKey = @"padding";
static NSString * const SpacingKey = @"spacing";
static NSString * const BorderThicknessKey = @"border-thickness";
static NSString * const BorderColorKey = @"border-color";
static NSString * const BackgroundColorKey = @"background-color";
static NSString * const RedColorKey = @"red";
static NSString * const GreenColorKey = @"green";
static NSString * const BlueColorKey = @"blue";
static NSString * const SubviewLayoutKey = @"subview-layout";
static NSString * const SubviewsKey = @"subviews";

@implementation SquareLayoutJsonUtil

+ (SquareLayoutSquare *)getParentSquare:(NSData *)jsonData
{
    NSLog(@"Get Parent Square is called");
    NSError *parsingError;
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parsingError];
    // Get root-view dictionary
    NSDictionary *squareDictionary = [d objectForKey:RootKey];
    return [self buildSquare:squareDictionary];
}

+ (SquareLayoutSquare *)buildSquare:(NSDictionary *)jsonDictionary
{
    NSLog(@"Build Square is called");
    int padding = PaddingDefault;
    if ([jsonDictionary objectForKey:PaddingKey]) {
        padding = [[jsonDictionary objectForKey:PaddingKey] intValue];
    }
    int spacing = SpacingDefault;
    if ([jsonDictionary objectForKey:SpacingKey]) {
        spacing = [[jsonDictionary objectForKey:SpacingKey] intValue];
    }
    float borderThickness = BorderThicknessDefault;
    if ([jsonDictionary objectForKey:BorderThicknessKey]) {
        borderThickness = [[jsonDictionary objectForKey:BorderThicknessKey] intValue];
    }
    UIColor *borderColor = [self buildColor:[jsonDictionary objectForKey:BorderColorKey] defaultColor:[UIColor blackColor]];
    UIColor *backgroundColor = [self buildColor:[jsonDictionary objectForKey:BackgroundColorKey] defaultColor:[UIColor clearColor]];
    NSString *subviewLayout = SubviewLayoutDefault;
    if ([jsonDictionary objectForKey:SubviewLayoutKey]) {
        subviewLayout = [jsonDictionary objectForKey:SubviewLayoutKey];
    }
    NSArray *subviewArray = [jsonDictionary objectForKey:SubviewsKey];
    NSMutableArray *childSquares = [[NSMutableArray alloc] init];
    if (subviewArray && [subviewArray count]>0) {
        for (id childJsonDictionary in subviewArray) {
            [childSquares addObject:[self buildSquare:childJsonDictionary]];
    
        }
    }
    SquareLayoutSquare *square = [[SquareLayoutSquare alloc] initWithPadding:padding spacing:spacing borderThickness:borderThickness borderColor:borderColor backgroundColor:backgroundColor subviewLayout:subviewLayout subviews:childSquares];
    return square;
}

+ (UIColor *)buildColor:(NSDictionary *)jsonDictionary defaultColor:(UIColor *)defaultColor
{
    NSLog(@"Build Color is called");
    UIColor *resultColor = defaultColor;
    if (jsonDictionary) {
        if ([jsonDictionary objectForKey:RedColorKey] && [jsonDictionary objectForKey:GreenColorKey] && [jsonDictionary objectForKey:BlueColorKey]) {
            float red = [[jsonDictionary objectForKey:RedColorKey] floatValue];
            float green = [[jsonDictionary objectForKey:GreenColorKey] floatValue];
            float blue = [[jsonDictionary objectForKey:BlueColorKey] floatValue];
            resultColor = [UIColor colorWithRed:(red*255.0)/255.0 green:(green*255.0)/255.0 blue:(blue*255.0)/255.0 alpha:1.0];
        }
    }
    return resultColor;
}


@end
