//
//  EditViewController.h
//  Friend
//
//  Created by Lee Penny on 5/30/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol EditViewDelegate

-(void)finishEditing;
@optional
-(void)cancelEditing;
@end

@interface EditViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    IBOutlet UIImageView *photo;
    IBOutlet UILabel *btName;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *phoneField;
    
    AppDelegate *shareSource;
    NSString *imagePath;
    
    BOOL newOrNot;
    NSInteger index;
    NSString *bt;
    
}

@property (nonatomic, strong)id <EditViewDelegate> delegate;
@property (nonatomic, strong)IBOutlet UILabel *btName;
@property (nonatomic, assign)BOOL newOrNot;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSString *bt;

-(IBAction)saveInfo:(id)sender;
-(IBAction)pressCancel:(id)sender;
-(IBAction)takePhoto:(id)sender;
@end
