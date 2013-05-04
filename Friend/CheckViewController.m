//
//  CheckViewController.m
//  Friend
//
//  Created by Lee Penny on 5/29/12.
//  Copyright (c) 2012 NTU. All rights reserved.
//

#import "CheckViewController.h"


@interface CheckViewController ()

@end

@implementation CheckViewController
@synthesize pageControl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
	// Do any additional setup after loading the view.
    sharedSource=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    double total=[sharedSource.btPairs count];
    numberOfPages=ceil(total/TILE_COUNT);
    
    //for test
    //numberOfPages=3;
    NSLog(@"numofPages: %d", numberOfPages);
    

    pageControl.numberOfPages=numberOfPages;
    pageControl.currentPage=0;
    
    
    CGRect frame = CGRectMake(0,44,320,352);
    checkScrollView=[[CheckScrollView alloc] initWithFrame:frame];
    if (checkScrollView) {
        NSLog(@"scrollView is inited");
    //NSLog(@"frame (x,y): ( %f, %f), (%f,%f)", scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
        checkScrollView.contentSize = CGSizeMake(checkScrollView.frame.size.width * numberOfPages, checkScrollView.frame.size.height);
        checkScrollView.numberOfPages=numberOfPages;
        checkScrollView.delegate=self;
        checkScrollView.checkController=self;
        checkScrollView.currentPage=0;
        checkScrollView.totalIndex=[sharedSource.btPairs count];;
        [checkScrollView createTiles];
        [self.view addSubview:checkScrollView];

    }

}

- (void)viewDidAppear:(BOOL)animated{
   // NSLog(@"checkView did appear");
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollView delegate");
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //NSLog(@"contentOffset ( %f, %f)",scrollView.contentOffset.x, scrollView.contentOffset.y);
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    checkScrollView.currentPage=page;
    //NSLog(@"currentPage: %d", page);

}

-(IBAction)pressEdit:(id)sender{
    
    if (checkScrollView.editOrNot) {
        NSLog(@"edit enable");
        [checkScrollView deleteDone];
        editItem.style=UIBarButtonSystemItemDone;
        [editItem setTitle:@"Delete"];
        checkScrollView.editOrNot=false;
    }else {
        NSLog(@"done enable");
        [checkScrollView beginDelete];
        editItem.style=UIBarButtonSystemItemEdit;
        [editItem setTitle:@"Done"];
        checkScrollView.editOrNot=true;
    }
}


@end
