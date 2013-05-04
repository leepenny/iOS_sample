//
//  CALayer+Additions.m
//  Tiles
//

#import "CALayer+Additions.h"


@implementation CALayer (Additions)


- (void)moveToFront {
    CALayer *superlayer = self.superlayer;
    [self removeFromSuperlayer];
    [superlayer addSublayer:self];
}


@end

@implementation CALayer (Additions2)

- (void)drawImage:(UIImage *)image{
    
    CALayer *superlayer=self.superlayer;
    [self removeFromSuperlayer];
    self.contents=(id)image.CGImage;
    self.borderColor=[UIColor blackColor].CGColor;
    self.borderWidth=1.0;
    self.masksToBounds=YES;
    [superlayer addSublayer:self];
};

@end