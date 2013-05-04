//
//  DeviceViewController.h
//  Friend
//
//  Created by Lee Penny on 5/29/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddDeviceViewController.h"
#import "EditViewController.h"

@interface DeviceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,AddDeviceDelegate, EditViewDelegate>{
    
    AppDelegate *shareSource;
    IBOutlet UITableView *table;
    
    
}




@end
