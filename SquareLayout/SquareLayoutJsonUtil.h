//
//  SquareLayoutJsonUtil.h
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SquareLayoutSquare;

@interface SquareLayoutJsonUtil : NSObject
{
    
}

+ (SquareLayoutSquare *)getParentSquare:(NSData *)jsonData;

@end
