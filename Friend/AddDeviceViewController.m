//
//  AddDeviceViewController.m
//  Friend
//
//  Created by Lee Penny on 5/30/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController
@synthesize delegate;

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
    NSLog(@"add device view");
    searchBT=[[NSMutableArray alloc] init];
    selectedIndex=-1;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)pressDone:(id)sender{
    [delegate finishAdding];
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)searchOrNot:(NSString *)name{
    
    for(NSDictionary *info in searchBT){
        if ([[info objectForKey:@"btName"] isEqualToString:name]) {
            return true;
        }
        
    }
    return false;
}

-(IBAction)findBT:(id)sender{
    NSLog(@"find bt");
    
    if (!loadingView.isAnimating) {
        [loadingView startAnimating];
    }
    table.allowsSelection=NO;
    table.alpha=0.5;
    
    //just for test
    for (int i=0; i < 10; i++) {
        NSString *btname=[NSString stringWithFormat:@"BT_%d",i];
        
        if ([self searchOrNot:btname]) {
            continue;
        }
        
        BOOL selected=[delegate selectedOrNot:btname];
        
        NSString *flag;
        if (selected) {
            flag=@"true";
            NSLog(@"selected is true");
        }else {
            flag=@"false";
            NSLog(@"selected is false");
        }
        
        NSArray *fields=[[NSArray alloc] initWithObjects:@"btName",@"selected", nil];
        NSArray *values=[[NSArray alloc] initWithObjects:btname,flag, nil];
        NSDictionary *btObj=[[NSDictionary alloc] initWithObjects:values forKeys:fields];
        [searchBT addObject:btObj];
            
        
    }
    
    [loadingView stopAnimating];
    table.alpha=1;
    table.allowsSelection=YES;
    [table reloadData];
}

/*
 * implement tableView delegate
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchBT count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BlueTooth"];
    
    //NSLog(@"indexPath row: %d", [indexPath row]);
    NSDictionary *dic=[searchBT objectAtIndex:[indexPath row]];
    
    
    if ([[dic objectForKey:@"selected"] isEqualToString:@"true"]) {
        NSLog(@"selected!");
        cell.textLabel.textColor=[UIColor redColor];
    }else {
        cell.textLabel.textColor=[UIColor blackColor];
    }
    cell.textLabel.text=[dic objectForKey:@"btName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=[searchBT objectAtIndex:[indexPath row]];
    //NSLog(@"select indexPath row: %d", [indexPath row]);
    if ([[dic objectForKey:@"selected"] isEqualToString:@"true"]) {
        NSLog(@"already selected");
        [tableView deselectRowAtIndexPath: indexPath animated: YES];
        return;
    }
    

    selectedIndex=[indexPath row];
    EditViewController *editView=[[EditViewController alloc] init];
    editView.newOrNot=true;
    editView.index=-1;
    editView.delegate=self;
    editView.bt=[dic objectForKey:@"btName"];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [self presentModalViewController:editView animated:YES];
}


/*
 * implement EditView delegate
 */
-(void)cancelEditing{
    selectedIndex=-1;
}

-(void)finishEditing{
    
    NSDictionary *dic=[searchBT objectAtIndex:selectedIndex];
    NSLog(@"indexPath row: %d", selectedIndex);
    if ([[dic objectForKey:@"selected"] isEqualToString:@"true"]) {
        NSLog(@"finishEditing at already selected");
        
        return;
    }
    
    NSArray *fields=[[NSArray alloc] initWithObjects:@"btName",@"selected", nil];
    NSArray *values=[[NSArray alloc] initWithObjects:[dic objectForKey:@"btName"],@"true", nil];
    NSDictionary *btObj=[[NSDictionary alloc] initWithObjects:values forKeys:fields];
    [searchBT replaceObjectAtIndex:selectedIndex withObject:btObj];
    [table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
