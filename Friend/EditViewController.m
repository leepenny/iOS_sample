//
//  EditViewController.m
//  Friend
//
//  Created by Lee Penny on 5/30/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController
@synthesize delegate;
@synthesize btName;
@synthesize newOrNot;
@synthesize index;
@synthesize bt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shareSource=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    imagePath=@"default";
    if (!newOrNot) {//called by DeviceView
        NSLog(@"called by DeviceView");
        NSDictionary *personInfo=[shareSource.btPairs objectAtIndex:index];
        btName.text=[personInfo objectForKey:@"btName"];
        bt=btName.text;
        nameField.text=[personInfo objectForKey:@"Name"];
        phoneField.text=[personInfo objectForKey:@"phone"];
        imagePath=[personInfo objectForKey:@"imagePath"];
        if (![imagePath isEqualToString:@"default"]) {
            NSString *imageName=[[NSString alloc] initWithFormat:@"Documents/%@",btName.text];
            NSString *Path= [NSHomeDirectory() stringByAppendingPathComponent:imageName];
            photo.image=[UIImage imageWithContentsOfFile:Path];
        }
    }else {
        NSLog(@"bt: %@",bt);
        btName.text=bt;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	return YES;
}

-(IBAction)saveInfo:(id)sender{
    
    if ([nameField.text isEqualToString:@""]) {
        NSLog(@"nameField is empty");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You should enter the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSLog(@"namefield: %@",nameField.text);
    NSLog(@"phoneField: %@", phoneField.text);
    NSLog(@"btName.text: %@", btName.text);
    //NSLog(@"1");
    if (imagePath==nil) {
        NSLog(@"imagePath is nil");
    }
    //NSLog(@"2");
    NSLog(@"imagePath: %@", imagePath);
    
    NSArray *fields=[[NSArray alloc] initWithObjects:@"Name",@"phone",@"btName",@"imagePath", nil];
    //NSLog(@"3");
    NSArray *values=[[NSArray alloc] initWithObjects:nameField.text,phoneField.text,btName.text, imagePath, nil];
    //NSLog(@"4");
    NSDictionary *btObj=[[NSDictionary alloc] initWithObjects:values forKeys:fields];
    //NSLog(@"5");
    if (!newOrNot) {
        [shareSource addToBtPairs:btObj atIndex:index];
        
    }else {
        [shareSource addToBtPairs:btObj atIndex:-1];
    }
    //NSLog(@"6");
    [delegate finishEditing];
    //NSLog(@"7");
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)pressCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)takePhoto:(id)sender{
    NSLog(@"take photo");
    //NSLog(@"%@===\n",NSStringFromSelector(_cmd));
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    
    //    if ([self.toggleCamera isOn]) {
    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    //	} else {
    //         imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    //     }
	imagePicker.delegate=self;
    imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%@=====\n",NSStringFromSelector(_cmd));
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@=====\n",NSStringFromSelector(_cmd));
    NSError *error;
    /* UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
     UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
     [imageView setFrame:CGRectMake(0.0, 0.0, 160.0, 240.0)];
     [imageView setCenter:self.view.center];
     
     [self.view addSubview:imageView]; */
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
    
    photo.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //UIImageWriteToSavedPhotosAlbum(photo.image, nil, nil, nil); 
    
    NSString *imageName=[[NSString alloc] initWithFormat:@"Documents/%@",btName.text];
    imagePath= [NSHomeDirectory() stringByAppendingPathComponent:imageName];
    [UIImageJPEGRepresentation(photo.image, 1.0) writeToFile:imagePath atomically:YES];
    imagePath=@"User";
    NSLog(@"imagePath: %@", imagePath);
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    NSLog(@"%@===================\n",NSStringFromSelector(_cmd)); 
    
    
    // dismiss the Camera
    [self dismissModalViewControllerAnimated:YES];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
