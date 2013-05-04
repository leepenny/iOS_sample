//
//  Tile.h
//  Tiles
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAGradientLayer.h>
#import "CALayer+Additions.h"


@interface Tile : CAGradientLayer {
    int tileIndex;
    
    UIImage *photo;
    NSString *name;
    
    BOOL deleteEnabled;
}

@property (nonatomic) int tileIndex;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL deleteEnabled;

- (void)draw;

- (void)appearDraggable;

- (void)appearNormal;

- (void)startWiggling;

- (void)stopWiggling;

@end
