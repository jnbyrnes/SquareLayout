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
#import "SquareView.h"

static NSString * const JsonFileName = @"square_hierarchy_structure";
static NSString * const JsonFileType = @"json";
static NSString * const SubviewLayoutHorizontal = @"horizontal";
static NSString * const SubviewLayoutVertical = @"vertical";

static NSString * const DictionaryMovedSquareKey = @"moved";
static NSString * const DictionaryParentSquareKey = @"parent";
static NSString * const DictionaryDestinationSquareKey = @"destination";

@implementation SquareLayoutViewController

- (id)init
{
    self = [super init];
    if (self) {
        // custom initialization
        [self.view setBackgroundColor:[UIColor clearColor]];
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
        CGRect rootFrame = [DisplayUtil getRootFrame:self.view];
        [self buildViewHierarchy:rootSquare view:self.view frame:rootFrame];
    }
}

- (void)buildViewHierarchy:(SquareLayoutSquare *)itemSquare view:(UIView *)itemView frame:(CGRect)itemFrame
{
    if (itemSquare && itemView) {
        NSLog(@"Processing Square Id: %d", [itemSquare squareId]);
        // build parent view
        UIView *parentView = [self buildSquareView:itemSquare frame:itemFrame];
        [itemView addSubview:parentView];
        // build child views
        int numSubviews = [[itemSquare subviews] count];
        float totalSubviewsOffset = [itemSquare padding] + [itemSquare borderThickness];
        float totalSubviewsAbstractWidth;
        float totalSubviewsAbstractHeight;
        if (numSubviews > 0) {
            // Determine horizontal or vertical subview layout
            if ([SubviewLayoutHorizontal isEqualToString:[itemSquare subviewLayout]]) {
                totalSubviewsAbstractWidth = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
                totalSubviewsAbstractHeight = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
            } else {
                totalSubviewsAbstractWidth = itemFrame.size.width - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2);
                totalSubviewsAbstractHeight = itemFrame.size.height - ([itemSquare borderThickness]*2) - ([itemSquare padding]*2) - ((numSubviews-1)*[itemSquare spacing]);
            }
            // Loop through subviews creating the view
            for (int i = 0; i < numSubviews; i++) {
                SquareLayoutSquare *subviewSquare = [[itemSquare subviews] objectAtIndex:i];
                float subviewWidth;
                float subviewX;
                float subviewHeight;
                float subviewY;
                // Determine horizontal or vertical subview layout
                if ([SubviewLayoutHorizontal isEqualToString:[itemSquare subviewLayout]]) {
                    subviewHeight = totalSubviewsAbstractHeight;
                    subviewWidth = (totalSubviewsAbstractWidth/numSubviews);
                    subviewX = totalSubviewsOffset + (i*subviewWidth) + ((i)*[itemSquare spacing]);
                    subviewY = totalSubviewsOffset;
                } else {
                    subviewHeight = (totalSubviewsAbstractHeight/numSubviews);
                    subviewWidth = totalSubviewsAbstractWidth;
                    subviewX = totalSubviewsOffset;
                    subviewY = totalSubviewsOffset + (i*subviewHeight) + ((i)*[itemSquare spacing]);
                }
                [self buildViewHierarchy:subviewSquare view:parentView frame:CGRectMake(subviewX, subviewY, subviewWidth, subviewHeight)];
            }
        }
        
    }
}

- (UIView *)buildSquareView:(SquareLayoutSquare *)itemSquare frame:(CGRect)itemFrame
{
    SquareView *view = [[SquareView alloc] initWithFrame:itemFrame];
    [view setSquare:itemSquare];
    [view setDelegate:self];
    [itemSquare setRectangle:itemFrame];
    [view setBackgroundColor:[itemSquare backgroundColor]];
    [[view layer] setBorderColor:[[itemSquare borderColor] CGColor]];
    [[view layer] setBorderWidth:[itemSquare borderThickness]];
    return view;
}

- (void)removeSquare:(int)squareId
{
    if (rootSquare) {
        if ([rootSquare squareId]==squareId) {
            rootSquare = nil;
        } else {
            [self processChildSquareRemoval:squareId withCurrentSquare:rootSquare];
            [self redrawSquareViews];
        }
    }
}

- (void)processChildSquareRemoval:(int)squareId withCurrentSquare:(SquareLayoutSquare *)currentSquare
{
    NSMutableArray *subViewArray = [currentSquare subviews];
    if (subViewArray && [subViewArray count]>0) {
        for (SquareLayoutSquare *childSquare in subViewArray) {
            if ([childSquare squareId]==squareId) {
                [subViewArray removeObject:childSquare];
                return;
            } else {
                [self processChildSquareRemoval:squareId withCurrentSquare:childSquare];
            }
        }
    }
}

- (void)addChildrenSquares:(int)squareId
{
    if (rootSquare) {
        if ([rootSquare squareId]==squareId) {
            [self createRandomSquares:rootSquare];
        } else {
            [self processAddChildSquares:squareId withCurrentSquare:rootSquare];
            [self redrawSquareViews];
        }
    }
}

- (void)processAddChildSquares:(int)squareId withCurrentSquare:(SquareLayoutSquare *)currentSquare
{
    NSMutableArray *subViewArray = [currentSquare subviews];
    if (subViewArray && [subViewArray count]>0) {
        for (SquareLayoutSquare *childSquare in subViewArray) {
            if ([childSquare squareId]==squareId) {
                [self createRandomSquares:childSquare];
                return;
            } else {
                [self processAddChildSquares:squareId withCurrentSquare:childSquare];
            }
        }
    }
}

- (void)createRandomSquares:(SquareLayoutSquare *)currentSquare
{
    //pick random number
    NSInteger randomNumber = arc4random() % 3;
    for (int i=0; i<=randomNumber; i++) {
        [[currentSquare subviews] addObject:[SquareLayoutJsonUtil buildRandomSquare]];
    }
}

- (void)moveSquare:(int)squareId withEndingPoint:(CGPoint)endingPoint
{
    // Find smallest view that lies in endingPoint
    if (rootSquare) {
        if ([rootSquare squareId]==squareId) {
            // Do nothing, since moving root to root
        } else {
            NSMutableDictionary *resultDictionary = [self transferSquare:(int)squareId withEndingPoint:(CGPoint)endingPoint withCurrentSquare:rootSquare];
            SquareLayoutSquare *removedSquare = [resultDictionary objectForKey:DictionaryMovedSquareKey];
            SquareLayoutSquare *destinationSquare = [resultDictionary objectForKey:DictionaryDestinationSquareKey];
            SquareLayoutSquare *parentSquare = [resultDictionary objectForKey:DictionaryParentSquareKey];
            if (removedSquare && destinationSquare && parentSquare) {
                [[parentSquare subviews] removeObject:removedSquare];
                [[destinationSquare subviews] addObject:removedSquare];
            }
            [self redrawSquareViews];
        }
    }
}

- (NSMutableDictionary *)transferSquare:(int)squareId withEndingPoint:(CGPoint)endingPoint withCurrentSquare:(SquareLayoutSquare *)currentSquare
{
    // Find moved square by squareId
    SquareLayoutSquare *removedSquare;
    // Find parent of moved square
    SquareLayoutSquare *parentSquare;
    // Determine smallest square that point lies inside
    SquareLayoutSquare *destinationSquare;
    NSMutableArray *subViewArray = [currentSquare subviews];
    if (subViewArray && [subViewArray count]>0) {
        for (SquareLayoutSquare *childSquare in subViewArray) {
            if ([childSquare squareId]==squareId) {
                removedSquare = childSquare;
                parentSquare = currentSquare;
            } else {
                if (CGRectContainsPoint([childSquare rectangle],endingPoint)) {
                    destinationSquare = childSquare;
                }
                NSMutableDictionary *tempDictionary = [self transferSquare:(int)squareId withEndingPoint:(CGPoint)endingPoint withCurrentSquare:childSquare];
                SquareLayoutSquare *tempRemovedSquare = [tempDictionary objectForKey:DictionaryMovedSquareKey];
                SquareLayoutSquare *tempParentSquare = [tempDictionary objectForKey:DictionaryParentSquareKey];
                SquareLayoutSquare *tempDestinationSquare = [tempDictionary objectForKey:DictionaryDestinationSquareKey];
                if (!removedSquare && tempRemovedSquare) {
                    removedSquare = tempRemovedSquare;
                }
                if (!parentSquare && tempParentSquare) {
                    parentSquare = tempParentSquare;
                }
                if (tempDestinationSquare) {
                    if (!destinationSquare) {
                        destinationSquare = tempDestinationSquare;
                    } else {
                        if (destinationSquare.rectangle.size.width>tempDestinationSquare.rectangle.size.width) {
                            destinationSquare = tempDestinationSquare;
                        }
                    }
                }
            }
        }
    }
    // Move Square
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    if (removedSquare) {
        [resultDictionary setObject:removedSquare forKey:DictionaryMovedSquareKey];
    }
    if (parentSquare) {
        [resultDictionary setObject:parentSquare forKey:DictionaryParentSquareKey];
    }
    if (destinationSquare) {
        [resultDictionary setObject:destinationSquare forKey:DictionaryDestinationSquareKey];
    }
    return resultDictionary;
}

- (void)redrawSquareViews
{
    // Remove All subviews
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // Perform Reload View
    [self processRootSquare];
}

// Handle Rotation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self redrawSquareViews];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
