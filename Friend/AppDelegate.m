//
//  AppDelegate.m
//  Friend
//
//  Created by Lee Penny on 5/29/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize btPairs;
@synthesize filePath;
@synthesize delegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //create filePath
    NSLog(@" create filePath");
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory=[paths objectAtIndex:0];
    filePath=[[NSString alloc] initWithString:[directory stringByAppendingPathComponent:@"btPairs"]];
    
    //retrieve file if there exists
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:filePath]) {
        btPairs=[[NSMutableArray alloc] initWithContentsOfFile:filePath];
        NSLog(@"# of btPairs: %d",[btPairs count]);
    }else {
        NSLog(@"init btPairs");
        btPairs=[[NSMutableArray alloc] init];
    }

    
    return YES;
}

-(BOOL)addToBtPairs:(NSDictionary *)obj atIndex:(NSInteger)index{
    
    if (index < 0) {//it is a new item
       [btPairs addObject:obj]; 
    }else {
        [btPairs replaceObjectAtIndex:index withObject:obj];
    }
    
    if([btPairs writeToFile:filePath atomically:YES]) {
        NSLog(@"writeToFile succeed");
        [delegate addTile:obj atIndex:index];
        return true;
    }
    else{
        NSLog(@"writeToFile failed");
        return false;
    }
}

-(BOOL)deleteFromBtPairs:(NSInteger)index{
    
    NSLog(@"delete object at %d", index);
    [btPairs removeObjectAtIndex:index];
    if ([btPairs writeToFile:filePath atomically:YES]) {
        NSLog(@"write to file succeed");
        [delegate deleteTile:index];
        return true;
    }else {
        NSLog(@"write to file failed");
        return false;
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
