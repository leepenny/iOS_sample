//
//  CheckScrollView.h
//  Friend
//
//  Created by Lee Penny on 6/4/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EditViewController.h"
#import "CheckViewController.h"
#define TILE_ROWS    4
#define TILE_COLUMNS 4
#define TILE_COUNT   (TILE_ROWS * TILE_COLUMNS)


@class CheckViewController;
@class Tile;

@interface MyLayerDelegate : NSObject

@end

@interface CheckScrollView : UIScrollView<SharedSourceDelegate, EditViewDelegate>{
    
    AppDelegate *sharedSource;
    CheckViewController *checkController;
    MyLayerDelegate *layerDelegate;
    
    NSInteger numberOfPages;
    NSInteger currentPage;
    
    NSInteger totalIndex;
    
    NSMutableArray   *tileFrame;
    NSMutableArray   *tileForFrame;
    
    Tile    *heldTile;
    int      heldFrameIndex;
    CGPoint  heldStartPosition;
    CGPoint  touchStartLocation;
    
    BOOL editOrNot;
    NSMutableArray *deleteTiles;
    
    BOOL changePageEnabled;
    NSTimer *timer;
}
@property (nonatomic, strong)AppDelegate *sharedSource;
@property (nonatomic, strong)CheckViewController *checkController;
@property (nonatomic, strong)MyLayerDelegate *layerDelegate;
@property (nonatomic, assign)NSInteger numberOfPages;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger totalIndex;
@property (nonatomic, assign)BOOL editOrNot;

-(void)createTiles;
-(void)beginDelete;
-(void)deleteDone;
-(void)enablePage:(NSTimer *)theTimer;
@end
