//
//  AppDelegate.h
//  Friend
//
//  Created by Lee Penny on 5/29/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharedSourceDelegate

-(void)addTile:(NSDictionary *)newObj atIndex:(NSInteger)index;
-(void)deleteTile:(NSInteger)index;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    NSMutableArray *btPairs;
    NSString *filePath;
}

@property (nonatomic, strong) id<SharedSourceDelegate> delegate;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *btPairs;
@property (nonatomic, strong) NSString *filePath;

-(BOOL)addToBtPairs:(NSDictionary *)obj atIndex:(NSInteger)index;
-(BOOL)deleteFromBtPairs:(NSInteger)index;

@end
