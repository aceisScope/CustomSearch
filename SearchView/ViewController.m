//
//  ViewController.m
//  SearchView
//
//  Created by B.H. Liu on 12-6-4.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import "ViewController.h"
#import "CustomSearchView.h"

@interface ViewController () <SearchViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CustomSearchView *searchView = [[CustomSearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:searchView];
    searchView.delegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark- SearchViewDelegate
- (void)selectOnResult:(NSDictionary *)result
{
    
}

@end
