//
//  SquareLayoutSquare.h
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareLayoutSquare : NSObject
{

}

@property (nonatomic) int padding;
@property (nonatomic) int spacing;
@property (nonatomic) float borderThickness;
@property (nonatomic) BOOL root;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *subviewLayout;
@property (nonatomic, strong) NSArray *subviews;


- (id)initWithPadding:(int)itemPadding spacing:(int)itemSpacing borderThickness:(float)itemBorderThickness root:(BOOL)itemRoot borderColor:(UIColor *)itemBorderColor backgroundColor:(UIColor *)itemBackgroundColor subviewLayout:(NSString *)itemSubviewLayout subviews:(NSArray *)itemSubviews;


@end
