//
//  AddDeviceViewController.h
//  Friend
//
//  Created by Lee Penny on 5/30/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@protocol AddDeviceDelegate 
-(BOOL)selectedOrNot:(NSString *)btName;
-(void)finishAdding;
@end


@interface AddDeviceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EditViewDelegate>{
    
    NSMutableArray *searchBT;
    
    IBOutlet UIActivityIndicatorView *loadingView;
    IBOutlet UITableView *table;
    
    NSString *selectedBt;
    NSInteger selectedIndex;
}
@property(nonatomic, strong) id<AddDeviceDelegate> delegate;

-(IBAction)pressDone:(id)sender;
-(IBAction)findBT:(id)sender;
@end
