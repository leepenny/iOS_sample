//
//  DeviceViewController.m
//  Friend
//
//  Created by Lee Penny on 5/29/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import "DeviceViewController.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

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
    NSLog(@"Device view");
    shareSource=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (shareSource==nil) {
        NSLog(@"shareSource can't be inited");
        return;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [table reloadData];
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



/*
 * implement tableView delegate
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [shareSource.btPairs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"pairer"];
    
    NSDictionary *info=[shareSource.btPairs objectAtIndex:[indexPath row]];
    
    cell.textLabel.text=[info objectForKey:@"Name"];
    if (![[info objectForKey:@"imagePath"] isEqualToString:@"default"]) {
        NSString *imageName=[[NSString alloc] initWithFormat:@"Documents/%@",[info objectForKey:@"btName"]];
        NSString *Path= [NSHomeDirectory() stringByAppendingPathComponent:imageName];
        cell.imageView.image=[UIImage imageWithContentsOfFile:Path];
    }else {
        cell.imageView.image=[UIImage imageNamed:@"painter-57x57.png"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EditViewController *editView=[[EditViewController alloc] init];
    editView.newOrNot=false;
    editView.index=[indexPath row];
    editView.delegate=self;
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [self presentModalViewController:editView animated:YES];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath   {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        if ([shareSource deleteFromBtPairs:[indexPath row]]) {
            NSLog(@"delete obj succeed");
            [table reloadData];
    
        }else {
            NSLog(@"delete obj failed");
        }
        
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toAddDeviceView"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}
/*
 * implement Add view delegate
 */
-(BOOL)selectedOrNot:(NSString *)btName{
    
    for(NSDictionary *info in shareSource.btPairs){
        if ([[info objectForKey:@"btName"] isEqualToString:btName]) {
            return true;
        }
    }
    return false;
    
}
-(void)finishAdding{
    [table reloadData];
}

/*
 * implement Edit view delegate
 */
-(void)finishEditing{
    [table reloadData];
}

@end
