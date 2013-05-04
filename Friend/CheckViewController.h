//
//  CheckViewController.h
//  Friend
//
//  Created by Lee Penny on 5/29/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CheckScrollView.h"

@class CheckScrollView;

@interface CheckViewController : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet CheckScrollView *checkScrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIBarButtonItem *editItem;

    
    NSInteger numberOfPages;
    AppDelegate *sharedSource;
}
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

-(IBAction)pressEdit:(id)sender;

@end
