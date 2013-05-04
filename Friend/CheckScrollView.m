//
//  CheckScrollView.m
//  Friend
//
//  Created by Lee Penny on 6/4/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import "CheckScrollView.h"
#import "Tile.h"
#import <QuartzCore/QuartzCore.h>


#define TILE_WIDTH  57
#define TILE_HEIGHT 68
#define TILE_MARGIN 18
#define IMAGE_MARGIN 2

@implementation MyLayerDelegate
- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    NSLog(@"begin drawlayer");
    Tile *tile = (Tile *)layer;
    UIImage *photo=tile.photo;
    CGRect photoRect=CGRectMake(tile.bounds.origin.x+IMAGE_MARGIN, tile.bounds.origin.y+IMAGE_MARGIN, TILE_WIDTH-2*IMAGE_MARGIN, TILE_WIDTH-2*IMAGE_MARGIN);
    
    UIGraphicsBeginImageContext(CGSizeMake(TILE_WIDTH-2*IMAGE_MARGIN,TILE_WIDTH-2*IMAGE_MARGIN));
    UIGraphicsPushContext(ctx);
    
    [tile draw];
    [[UIBezierPath bezierPathWithRoundedRect:photoRect cornerRadius:8.0] addClip];
    [photo drawInRect:photoRect];
    
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    NSLog(@"end drawlayer");
}
@end

@implementation CheckScrollView
@synthesize sharedSource;
@synthesize layerDelegate;
@synthesize checkController;
@synthesize numberOfPages;
@synthesize currentPage;
@synthesize totalIndex;
@synthesize editOrNot;


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        NSLog(@"init with frame");
        //[self createTiles];
        sharedSource=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        sharedSource.delegate=self;
        self.layerDelegate=[[MyLayerDelegate alloc] init];
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake(frame.size.width * 1, frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        changePageEnabled=YES;
        //self.delegate = self;
        self.editOrNot=false;
        self.backgroundColor=[UIColor blackColor];
        //[self createTiles];
    }
    return self;
}



- (void)createTiles {
    
    NSLog(@"createTiles");
    
    tileFrame=[[NSMutableArray alloc] init];
    tileForFrame=[[NSMutableArray alloc] init];
    
    UIColor *tileColors[] = {
        [UIColor blueColor],
        [UIColor brownColor],
        [UIColor grayColor],
        [UIColor clearColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor redColor],
    };
    int tileColorCount = sizeof(tileColors) / sizeof(tileColors[0]);
    
    for (int page = 0; page < numberOfPages; ++page) {
        
        for (int row = 0; row < TILE_ROWS; ++row) {
            for (int col = 0; col < TILE_COLUMNS; ++col) {
                int index = (page * TILE_COUNT)+(row * TILE_COLUMNS) + col;
                if (index == totalIndex) {
                    NSLog(@"create total done");
                    return;
                }
                
                CGRect frame = CGRectMake(page * self.frame.size.width+TILE_MARGIN + col * (TILE_MARGIN + TILE_WIDTH),
                                          TILE_MARGIN + row * (TILE_MARGIN + TILE_HEIGHT),
                                          TILE_WIDTH, TILE_HEIGHT);
                //NSLog(@"frame (x,y): (%f,%f)",frame.origin.x, frame.origin.y);
                //NSLog(@"index: %d", index);
                [tileFrame addObject:[NSValue valueWithCGRect:frame]];
                
               /* if (index >= totalIndex) {
                    [tileForFrame addObject:[NSNull null]];
                    continue;
                }*/
                NSDictionary *info=[sharedSource.btPairs objectAtIndex:index];
                
                Tile *tile = [[Tile alloc] init];
                tile.tileIndex = index;
                tile.name=[info objectForKey:@"Name"];
                
                NSString *photoPath=[info objectForKey:@"imagePath"];
                if (![photoPath isEqualToString:@"default"]) {
                    NSString *imageName=[[NSString alloc] initWithFormat:@"Documents/%@",[info objectForKey:@"btName"]];
                    NSString *Path= [NSHomeDirectory() stringByAppendingPathComponent:imageName];
                    tile.photo=[UIImage imageWithContentsOfFile:Path];
                }else {
                    tile.photo=[UIImage imageNamed:@"painter-57x57.png"];
                }
                
                tile.frame = frame;
                tile.backgroundColor = tileColors[index % tileColorCount].CGColor;

                tile.cornerRadius=8;
                [tileForFrame addObject:tile];
                /*
                 Warning: Since the view is the layer’s delegate, you should never set the view as a delegate of another CALayer object. Additionally, you should never change the delegate of this layer.
                 see the link:
                 http://stackoverflow.com/questions/2015353/using-calayer-delegate
                 */
                
                //layerDelegate=[[MyLayerDelegate alloc] init];
                tile.delegate =layerDelegate;
                
                if (tile.delegate==nil) {
                    NSLog(@"ERROR delegate is nil");
                }

                [tile setNeedsDisplay];
                [self.layer addSublayer:tile];
                //[tile drawImage:[UIImage imageNamed:@"painter-57x57.png"]];
                //tile.delegate=nil;
                
               // [tile release];
                
            }
        }
    }
   
    
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    NSLog(@"begin drawlayer");
    Tile *tile = (Tile *)layer;
    UIImage *photo=tile.photo;
    CGRect photoRect=CGRectMake(tile.bounds.origin.x+IMAGE_MARGIN, tile.bounds.origin.y+IMAGE_MARGIN, TILE_WIDTH-2*IMAGE_MARGIN, TILE_WIDTH-2*IMAGE_MARGIN);
    
    UIGraphicsBeginImageContext(CGSizeMake(TILE_WIDTH-2*IMAGE_MARGIN,TILE_WIDTH-2*IMAGE_MARGIN));
    UIGraphicsPushContext(ctx);
    
    [tile draw];
    [[UIBezierPath bezierPathWithRoundedRect:photoRect cornerRadius:8.0] addClip];
    [photo drawInRect:photoRect];
    
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    NSLog(@"end drawlayer");
}

-(void)showEditView:(Tile *)tapped{
    EditViewController *editView=[[EditViewController alloc] init];
    editView.newOrNot=false;
    editView.index=tapped.tileIndex;
    editView.delegate=self;
    [checkController presentModalViewController:editView animated:YES];
    
}

/*
 * implement EditView delegate
 */
-(void)finishEditing{
    NSLog(@"finish Edit");
}

-(void)cancelEditing{
    NSLog(@"cancel Edit");
}
/*
 *****************************
 */
-(void)beginDelete{
    if (deleteTiles==nil) {
        NSLog(@"deleTiles is nil");
        deleteTiles=[[NSMutableArray alloc] init];
    }else {
        [deleteTiles removeAllObjects];
    }
    
}

-(void)deleteDone{

    for(Tile *obj in deleteTiles){
        [sharedSource deleteFromBtPairs:obj.tileIndex];
        
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch began");
    
    CALayer *hitLayer = [self layerForTouch:[touches anyObject]];
    UITouch *touch = [[event allTouches] anyObject];
    //NSLog(@"touch (x,y): (%f,%f)", [touch locationInView:self].x, [touch locationInView:self].y);
    
    if ([hitLayer isKindOfClass:[Tile class]]) {
        
        Tile *tile = (Tile*)hitLayer;
        
        if (editOrNot) {
            
            if (tile.deleteEnabled) {
                tile.opacity=1.0;
                [[[tile sublayers] objectAtIndex:0] removeFromSuperlayer];
                [deleteTiles removeObject:tile];
                tile.deleteEnabled=NO;
            }else {
                CALayer *checkMark=[CALayer layer];
                checkMark.frame=CGRectMake(tile.bounds.origin.x+0.5*tile.frame.size.width, tile.bounds.origin.y+0.5*tile.frame.size.height, 0.5*tile.frame.size.width, 0.5*tile.frame.size.height);
                //NSLog(@"tile position (x,y): (%f,%f)",tile.bounds.origin.x, tile.bounds.origin.y);
                //NSLog(@"tile frame (x,y): (%f,%f)",tile.frame.origin.x, tile.frame.origin.y);
                //NSLog(@"checkMark frame (x,y): (%f,%f)",checkMark.frame.origin.x, checkMark.frame.origin.y);
                checkMark.backgroundColor=[UIColor redColor].CGColor
                ;
                checkMark.cornerRadius=8.0;
                checkMark.opacity=0.6;
                checkMark.contents=(id)[UIImage imageNamed:@"find-128x128.png"].CGImage;
                checkMark.masksToBounds=YES;
                
                tile.opacity=0.6;
                [tile addSublayer:checkMark];
                [deleteTiles addObject:tile];
                tile.deleteEnabled=YES;
            }
            
        }else {
            
            
            if ([touch tapCount] == 2) {
                NSLog(@"double tap");
                [self showEditView:tile];
                return;
            }
            
            self.scrollEnabled=NO;
            NSLog(@"hitLayer is Tile class");
            heldTile = tile;
            
            
            
            touchStartLocation = [[touches anyObject] locationInView:self];
            heldStartPosition = tile.position;
            NSLog(@"touch tile index: %d", tile.tileIndex);
            heldFrameIndex = [self frameIndexForTileIndex:tile.tileIndex];
            
            [tile moveToFront];
            [tile appearDraggable];
            [self startTilesWiggling];
        }
        
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if (heldTile) {
        UITouch *touch = [touches anyObject];
        UIView *view = self;
        CGPoint location = [touch locationInView:view];
        CGPoint locationInSuperView=[view convertPoint:location toView:view.superview];
        //NSTimeInterval time=[touch timestamp];
        //NSLog(@"time: %f",time);
        //NSLog(@"Moved=>location in superview (x,y): ( %f, %f )", locationInSuperView.x, locationInSuperView.y);
        if (locationInSuperView.x >= 300 && currentPage < numberOfPages-1 && changePageEnabled) {
            NSLog(@"go to right page");
            changePageEnabled=NO;
            currentPage++;
            CGPoint contentoffset=CGPointMake(currentPage*self.frame.size.width, 0);
            [self setContentOffset:contentoffset animated:YES];
            
            
        }
        else if (locationInSuperView.x <= 10 && currentPage > 0 && changePageEnabled) {
            NSLog(@"go to left page");
            changePageEnabled=NO;
            currentPage--;
            CGPoint contentoffset=CGPointMake(currentPage*self.frame.size.width, 0);
            [self setContentOffset:contentoffset animated:YES];
            
        }else{
            //NSLog(@"move Tile");
            if (!changePageEnabled && timer==nil) {
                timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(enablePage:) userInfo:nil repeats:NO];
            }
            [self moveHeldTileToPoint:location];
            //[self moveUnheldTilesAwayFromPoint:location];
        }
    }
}

-(void)enablePage:(NSTimer *)theTimer{
    NSLog(@"enble page change");
    changePageEnabled=YES;
    [timer invalidate];
    timer=nil;
}

- (void)moveHeldTileToPoint:(CGPoint)location {
    float dx = location.x - touchStartLocation.x;
    float dy = location.y - touchStartLocation.y;
    CGPoint newPosition = CGPointMake(heldStartPosition.x + dx, heldStartPosition.y + dy);
    
    [CATransaction begin];
    [CATransaction setDisableActions:TRUE];
    heldTile.position = newPosition;
    [CATransaction commit];
}


- (void)moveUnheldTilesAwayFromPoint:(CGPoint)location {
    int frameIndex = [self indexOfClosestFrameToPoint:location];
    //NSLog(@"heldFrameIndex: %d, frameIndex: %d", heldFrameIndex, frameIndex);
    if (frameIndex != heldFrameIndex) {
        [CATransaction begin];
        
       /* if ([tileForFrame objectAtIndex:frameIndex] == (Tile *)[NSNull null]) {
            NSLog(@"tile is null");
            
            
        }*/
        
        /*if (frameIndex < heldFrameIndex) {
            for (int i = heldFrameIndex; i > frameIndex; --i) {
                Tile *movingTile = [tileForFrame objectAtIndex:i-1];
                movingTile.frame = [[tileFrame objectAtIndex:i] CGRectValue];
                [tileForFrame replaceObjectAtIndex:i withObject:movingTile];
            }
        }
        else if (heldFrameIndex < frameIndex) {
            for (int i = heldFrameIndex; i < frameIndex; ++i) {
                Tile *movingTile = [tileForFrame objectAtIndex:i+1];
                movingTile.frame = [[tileFrame objectAtIndex:i] CGRectValue];
                [tileForFrame replaceObjectAtIndex:i withObject:movingTile];
            }
        }*/
        int temp=heldFrameIndex;
        Tile *tempTile=[tileForFrame objectAtIndex:frameIndex];
        tempTile.frame=[[tileFrame objectAtIndex:temp] CGRectValue];
        heldFrameIndex = frameIndex;
        [tileForFrame replaceObjectAtIndex:heldFrameIndex withObject:heldTile];
        [tileForFrame replaceObjectAtIndex:temp withObject:tempTile];
        
        [CATransaction commit];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch end");

    
    if (heldTile) {
        UITouch *touch = [touches anyObject];
        UIView *view = self;
        CGPoint location = [touch locationInView:view];
        [self moveUnheldTilesAwayFromPoint:location];
        
        [heldTile appearNormal];
        heldTile.frame = [[tileFrame objectAtIndex:heldFrameIndex] CGRectValue];
        heldTile = nil;
        self.scrollEnabled=YES;
    }
    [self stopTilesWiggling];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch cancel");
    
    [self touchesEnded:touches withEvent:event];
}


- (CALayer *)layerForTouch:(UITouch *)touch {
    UIView *view = self;
    
    CGPoint location = [touch locationInView:view];
    //NSLog(@"location in view (x,y): ( %f, %f )", location.x, location.y);
    location = [view convertPoint:location toView:view.superview];
    //NSLog(@"location in superview (x,y): ( %f, %f )", location.x, location.y);
    
    CALayer *hitPresentationLayer = [view.layer.presentationLayer hitTest:location];
    if (hitPresentationLayer) {
        NSLog(@"hitPresentationLayer isn't nil");
        return hitPresentationLayer.modelLayer;
    }
    
    return nil;
}


- (int)frameIndexForTileIndex:(int)tileIndex {
    for (int i = 0; i < totalIndex; ++i) {

        Tile *touchTile=[tileForFrame objectAtIndex:i];
        if (touchTile.tileIndex == tileIndex) {
            return i;
        }
    }
    return 0;
}


- (int)indexOfClosestFrameToPoint:(CGPoint)point {
    int index = 0;
    float minDist = FLT_MAX;
    for (int i = 0; i < totalIndex; ++i) {
        CGRect frame = [[tileFrame objectAtIndex:i] CGRectValue];
        
        float dx = point.x - CGRectGetMidX(frame);
        float dy = point.y - CGRectGetMidY(frame);
        
        float dist = (dx * dx) + (dy * dy);
        if (dist < minDist) {
            index = i;
            minDist = dist;
        }
    }
    return index;
}


- (void)startTilesWiggling {
    //NSLog(@"start wiggling");
    for (int i = 0; i < totalIndex; ++i) {
        Tile *tile = [tileForFrame objectAtIndex:i];
        if (tile != heldTile) {
            [tile startWiggling];
        }
    }
}


- (void)stopTilesWiggling {
   // NSLog(@"stop wiggling");
    for (int i = 0; i < totalIndex; ++i) {
        Tile *tile = [tileForFrame objectAtIndex:i];
        [tile stopWiggling];
    }
}

/*
 * implement SharedSource delegate
 */

-(void)addTile:(NSDictionary *)newObj atIndex:(NSInteger)index{
    
    if (index >=0) {
        NSLog(@"addTile, replace old");
        
        NSDictionary *info=newObj;
        
        int frameIndex=-1;
        for(Tile *obj in tileForFrame){
            frameIndex++;
            if (obj.tileIndex == index) {
                NSLog(@"index_%d 's frameIndex:%d", index,frameIndex);
                break;
            }
            
        }
        
        Tile *tile = [tileForFrame objectAtIndex:frameIndex];
        tile.name=[info objectForKey:@"Name"];
        
        NSString *photoPath=[info objectForKey:@"imagePath"];
        if (![photoPath isEqualToString:@"default"]) {
            NSString *imageName=[[NSString alloc] initWithFormat:@"Documents/%@",[info objectForKey:@"btName"]];
            NSString *Path= [NSHomeDirectory() stringByAppendingPathComponent:imageName];
            tile.photo=[UIImage imageWithContentsOfFile:Path];
        }else {
            tile.photo=[UIImage imageNamed:@"painter-57x57.png"];
        }
        
        //tile.frame = frame;
        //tile.backgroundColor = tileColors[index % tileColorCount].CGColor;
        
        
        [tile setNeedsDisplay];
        
        return;

    }
    
    NSLog(@"add Tile, add new");
    index=totalIndex++;
    UIColor *tileColors[] = {
        [UIColor blueColor],
        [UIColor brownColor],
        [UIColor grayColor],
        [UIColor clearColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor redColor],
    };
    int tileColorCount = sizeof(tileColors) / sizeof(tileColors[0]);
    
    int page=floor(index/TILE_COUNT);
    if (page >= numberOfPages) {
        numberOfPages++;
        self.contentSize = CGSizeMake(self.frame.size.width * numberOfPages, self.frame.size.height);
        checkController.pageControl.numberOfPages=numberOfPages;
    }
    int row=floor( (index-page*TILE_COUNT)/TILE_COLUMNS );
    int col=index-(page*TILE_COUNT)-(row*TILE_COLUMNS);
    
    CGRect frame = CGRectMake(page * self.frame.size.width+TILE_MARGIN + col * (TILE_MARGIN + TILE_WIDTH),
                              TILE_MARGIN + row * (TILE_MARGIN + TILE_HEIGHT),
                              TILE_WIDTH, TILE_HEIGHT);
    //NSLog(@"frame (x,y): (%f,%f)",frame.origin.x, frame.origin.y);
    NSLog(@"page:%d, row:%d, col:%d", page, row, col);
    NSLog(@"index: %d", index);
    [tileFrame addObject:[NSValue valueWithCGRect:frame]];
    
    NSDictionary *info=newObj;
    
    Tile* tile = [[Tile alloc] init];
    tile.tileIndex = index;
    tile.name=[info objectForKey:@"Name"];
    
    NSString *photoPath=[info objectForKey:@"imagePath"];
    if (![photoPath isEqualToString:@"default"]) {
        NSString *imageName=[[NSString alloc] initWithFormat:@"Documents/%@",[info objectForKey:@"btName"]];
        NSString *Path= [NSHomeDirectory() stringByAppendingPathComponent:imageName];
        tile.photo=[UIImage imageWithContentsOfFile:Path];
    }else {
        tile.photo=[UIImage imageNamed:@"painter-57x57.png"];
    }
    
    tile.frame = frame;
    tile.backgroundColor = tileColors[index % tileColorCount].CGColor;
    
    tile.cornerRadius=8;
    [tileForFrame addObject:tile];

    //MyLayerDelegate *layerDelegate=[[MyLayerDelegate alloc] init];
    tile.delegate =layerDelegate;
    
    [tile setNeedsDisplay];
    [self.layer addSublayer:tile];
}

-(void)deleteTile:(NSInteger)index{
    
    totalIndex--;
    

    
    int frameIndex=-1;
    for(Tile *obj in tileForFrame){
        frameIndex++;
        if (obj.tileIndex == index) {
            NSLog(@"index_%d 's frameIndex:%d", index,frameIndex);
            break;
        }
        
    }
    //NSLog(@"1");
    for (int i = frameIndex; i < totalIndex; ++i) {
        Tile *movingTile = [tileForFrame objectAtIndex:i+1];
        movingTile.frame = [[tileFrame objectAtIndex:i] CGRectValue];

    }
   // NSLog(@"2");
    for(Tile *obj in tileForFrame){
        
        if (obj.tileIndex > index) {
            obj.tileIndex--;
        }
        
    }
    //NSLog(@"3");
    Tile *deleted=[tileForFrame objectAtIndex:frameIndex];
    [deleted removeFromSuperlayer];
   // NSLog(@"4");
    double total=[sharedSource.btPairs count];
    int numPage=ceil(total/TILE_COUNT);
    if (numPage != numberOfPages) {
        numberOfPages=numPage;
        self.contentSize = CGSizeMake(self.frame.size.width * numberOfPages, self.frame.size.height);
        checkController.pageControl.numberOfPages=numberOfPages;
        
    }
    
    [tileForFrame removeObjectAtIndex:frameIndex];
    [tileFrame removeLastObject];
   // NSLog(@"5");
    
}

@end
