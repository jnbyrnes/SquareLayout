//
//  SquareLayoutViewController.m
//  SquareLayout
//
//  Created by Jeffrey Byrnes on 5/26/14.
//  Copyright (c) 2014 Jeffrey Byrnes. All rights reserved.
//

#import "SquareLayoutViewController.h"
#import "SquareLayoutSquare.h"
#import "SquareLayoutJsonUtil.h"

static NSString * const JsonFileName = @"square_hierarchy_structure";
static NSString * const JsonFileType = @"json";
static NSString * const SubviewLayoutHorizontal = @"horizontal";
static NSString * const SubviewLayoutVertical = @"vertical";

@implementation SquareLayoutViewController

- (id)init
{
    self = [super init];
    if (self) {
        // custom initialization
        NSLog(@"Initializing SquareLayoutViewController");
        [self loadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    NSLog(@"Load Data is called");
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        
        dispatch_sync(concurrentQueue, ^{
            NSString *filePath = [[NSBundle mainBundle] pathForResource:JsonFileName ofType:JsonFileType];
            NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
            if (jsonData) {
                rootSquare = [SquareLayoutJsonUtil getParentSquare:jsonData];
            }
        });
        
        // Perform Reload View
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!rootSquare) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Invalid Json file, please update %@.%@", JsonFileName, JsonFileType] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [av show];
            } else {
                // update the view
                CGRect rootFrame = [[[UIApplication sharedApplication] keyWindow] bounds];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                    // adjust for status bar on ios7
                    rootFrame.origin.y = rootFrame.origin.y + 20;
                    rootFrame.size.height = rootFrame.size.height - 20;
                }
                [self buildViewHierarchy:rootSquare view:[[UIApplication sharedApplication] keyWindow] frame:rootFrame];
            }
        });
    });
}

- (void)buildViewHierarchy:(SquareLayoutSquare *)itemSquare view:(UIView *)itemView frame:(CGRect)itemFrame
{
    NSLog(@"Build View Hierarchy is called");
    if (itemSquare && itemView) {
        // build parent view
        UIView *parentView = [self buildSquareView:itemSquare frame:itemFrame];
        [itemView addSubview:parentView];
        // build child views
        int numSubviews = [[itemSquare subviews] count];
        float totalSubviewsWidth = 0;
        float totalSubviewsOriginX = [itemSquare padding] + [itemSquare borderThickness];
        float totalSubviewsHeight = 0;
        float totalSubviewsOriginY = [itemSquare padding] + [itemSquare borderThickness];
        if (numSubviews > 0) {
            // Determine horizontal or vertical subview layout
            if ([SubviewLayoutHorizontal isEqualToString:[itemSquare subviewLayout]]) {
                totalSubviewsWidth = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
                totalSubviewsHeight = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
            } else {
                totalSubviewsWidth = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
                totalSubviewsHeight = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
            }
            // Loop through subviews creating the view
            for (int i = 0; i < numSubviews; i++) {
                SquareLayoutSquare *subviewSquare = [[itemSquare subviews] objectAtIndex:i];
                float subviewWidth = totalSubviewsWidth;
                float subviewX = totalSubviewsOriginX;
                float subviewHeight = totalSubviewsHeight;
                float subviewY = totalSubviewsOriginY;
                // Determine horizontal or vertical subview layout
                if ([SubviewLayoutHorizontal isEqualToString:[itemSquare subviewLayout]]) {
                    subviewX = subviewX + (i*totalSubviewsWidth/numSubviews);
                    if (i > 0) {
                        subviewX = subviewX + ((i)*[itemSquare spacing]);
                    }
                    subviewWidth = (totalSubviewsWidth/numSubviews);
                } else {
                    subviewY = subviewY + (i*totalSubviewsHeight/numSubviews);
                    if (i > 0) {
                        subviewY = subviewY + ((i)*[itemSquare spacing]);
                    }
                    subviewHeight = (totalSubviewsHeight/numSubviews);
                }
                // Check for orientation
                UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
                if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    NSLog(@"------------Orientation is in Portrait");
                    [self buildViewHierarchy:subviewSquare view:parentView frame:CGRectMake(subviewX, subviewY, subviewWidth, subviewHeight)];
                } else {
                    NSLog(@"------------Orientation is in Landscape");
                    [self buildViewHierarchy:subviewSquare view:parentView frame:CGRectMake(subviewY, subviewX, subviewHeight, subviewWidth)];
                }
            }
        }
        
    }
}

- (UIView *)buildSquareView:(SquareLayoutSquare *)itemSquare frame:(CGRect)itemFrame
{
    NSLog(@"Build Square View is called");
    UIView *view = [[UIView alloc] initWithFrame:itemFrame];
    [view setBackgroundColor:[itemSquare backgroundColor]];
    [[view layer] setBorderColor:[[itemSquare borderColor] CGColor]];
    [[view layer] setBorderWidth:[itemSquare borderThickness]];
    return view;
}

// Handle Rotation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"Did Rotate From Interface Orientation");
    // Perform Reload View
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (!rootSquare) {
            NSLog(@"Error");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Invalid Json file, please update %@.%@", JsonFileName, JsonFileType] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];
        } else {
            NSLog(@"Success");
            // remove all subviews
            [[[[UIApplication sharedApplication] keyWindow] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            // update the view
            [self buildViewHierarchy:rootSquare view:[[UIApplication sharedApplication] keyWindow] frame:[[[UIApplication sharedApplication] keyWindow] bounds]];
        }
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
