//
//  DisplayUtil.m
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/28/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import "DisplayUtil.h"

@implementation DisplayUtil

+ (CGRect)getRootFrame:(UIView *)mainWindow
{
    CGRect rootFrame = [mainWindow bounds];
    // adjust for status bar on ios7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        rootFrame.origin.y = rootFrame.origin.y + 20;
        rootFrame.size.height = rootFrame.size.height - 20;
    }
    return rootFrame;
}

@end
