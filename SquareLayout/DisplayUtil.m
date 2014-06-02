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
    // Check for orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        rootFrame.origin.y = rootFrame.origin.y + 20;
        rootFrame.size.height = rootFrame.size.height - 20;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        rootFrame.origin.x = rootFrame.origin.x + 20;
        rootFrame.size.width = rootFrame.size.width - 20;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        rootFrame.size.width = rootFrame.size.width - 20;
    } else {
        rootFrame.size.height = rootFrame.size.height - 20;
    }
    return rootFrame;
}

@end
