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
#import "DisplayUtil.h"

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
        mainWindow = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
        [mainWindow setBackgroundColor:[UIColor clearColor]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:mainWindow];
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
            // Load, Parse and Build Square objects
            NSString *filePath = [[NSBundle mainBundle] pathForResource:JsonFileName ofType:JsonFileType];
            NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
            if (jsonData) {
                rootSquare = [SquareLayoutJsonUtil getParentSquare:jsonData];
            }
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Perform Reload View
            [self processRootSquare];
        });
    });
}

- (void) processRootSquare
{
    if (!rootSquare) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Invalid Json file, please update %@.%@", JsonFileName, JsonFileType] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [av show];
    } else {
        // update the view
        CGRect rootFrame = [DisplayUtil getRootFrame:mainWindow];
        [self buildViewHierarchy:rootSquare view:mainWindow frame:rootFrame];
    }
}

- (void)buildViewHierarchy:(SquareLayoutSquare *)itemSquare view:(UIView *)itemView frame:(CGRect)itemFrame
{
    NSLog(@"Build View Hierarchy is called");
    if (itemSquare && itemView) {
        // build parent view
        UIView *parentView = [self buildSquareView:itemSquare frame:itemFrame];
        [itemView addSubview:parentView];
        // Check for orientation
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        // build child views
        int numSubviews = [[itemSquare subviews] count];
        float totalSubviewsWidth = 0;
        float totalSubviewsOriginX = [itemSquare padding] + [itemSquare borderThickness];
        float totalSubviewsHeight = 0;
        float totalSubviewsOriginY = [itemSquare padding] + [itemSquare borderThickness];
        if (numSubviews > 0) {
            // Determine horizontal or vertical subview layout
            if ([SubviewLayoutHorizontal isEqualToString:[itemSquare subviewLayout]]) {
                if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    totalSubviewsWidth = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
                    totalSubviewsHeight = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
                } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
                    totalSubviewsWidth = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
                    totalSubviewsHeight = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
                }
            } else {
                if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    totalSubviewsWidth = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
                    totalSubviewsHeight = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
                } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
                    totalSubviewsWidth = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
                    totalSubviewsHeight = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
                }
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
                    if (orientation == UIInterfaceOrientationLandscapeLeft) {
                        subviewX = totalSubviewsHeight - ((i)*subviewWidth) - ((i-1)*[itemSquare spacing]);
                    }
                } else {
                    subviewY = subviewY + (i*totalSubviewsHeight/numSubviews);
                    if (i > 0) {
                        subviewY = subviewY + ((i)*[itemSquare spacing]);
                    }
                    if (orientation == UIInterfaceOrientationLandscapeRight) {
                        subviewY = totalSubviewsHeight - subviewY - ((numSubviews+1)*[itemSquare spacing]);
                    }
                    subviewHeight = (totalSubviewsHeight/numSubviews);
                }
                if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    NSLog(@"------------Orientation is in Portrait");
                    [self buildViewHierarchy:subviewSquare view:parentView frame:CGRectMake(subviewX, subviewY, subviewWidth, subviewHeight)];
                } else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
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
    // Remove All subviews
    [[mainWindow subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // Perform Reload View
    [self processRootSquare];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"Will Rotate To Interface Orientation");
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"Supported Interface Orientations");
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    NSLog(@"Should AutoRotate");
    return YES;
}

@end
