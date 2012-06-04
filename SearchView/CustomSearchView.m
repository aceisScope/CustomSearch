//
//  CustomSearchView.m
//  NightShow
//
//  Created by B.H. Liu on 12-5-23.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import "CustomSearchView.h"
#import "SBJson.h"

@interface CustomSearchView() <KeyWordDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *resultTable;
@property (nonatomic,retain) NSArray *resultArray;
@end

@implementation CustomSearchView
@synthesize searchBar=_searchBar;
@synthesize resultTable=_resultTable;
@synthesize resultArray = _resultArray;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        self.resultArray = [NSArray array];
        
        self.backgroundColor = [UIColor colorWithRed:240./256 green:240./256 blue:240./256 alpha:1.f];
        
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 44.0)] autorelease];
        [self.searchBar setPlaceholder:@"Search for anything..."];
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        self.searchBar.tintColor = [UIColor colorWithRed:217./256 green:217./256 blue:217./256 alpha:1.]; 
        [self addSubview:self.searchBar];
        
        for(UIView *subView in self.searchBar.subviews)
        {
            if([subView isKindOfClass:UIButton.class])
            {
                //customize cancel button here
            }
        }
        
        HotKeyWordsView *keywordView = [[[HotKeyWordsView alloc]initWithFrame:CGRectMake(0, 54, self.bounds.size.width, 170)] autorelease];
        [self addSubview:keywordView];
        keywordView.delegate = self;
        keywordView.tag = 4001;
        [keywordView setKeyWords:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"keywords" ofType:@"json"] usedEncoding:nil error:nil]JSONValue]];
        
        self.resultTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, 170)] autorelease];
        [self.resultTable setDataSource:self];
        [self.resultTable setDelegate:self];
        self.resultTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.resultTable.backgroundColor = [UIColor colorWithRed:240./256 green:240./256 blue:240./256 alpha:1.f];
        self.resultTable.backgroundView = nil;
        self.resultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.resultTable];
        self.resultTable.hidden = YES;
        
    }
    return self;
}

- (void)dealloc
{
    self.searchBar = nil;
    self.resultTable = nil;
    self.resultArray = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(!self.resultTable.hidden) self.resultTable.hidden = YES;
}

- (void)reloadData
{
    //[(HotKeyWordsView*)[self viewWithTag:4001] setKeyWords:];
}


#pragma mark- KeyWordDelegate
- (void)selectOnKeyWord:(NSString *)word
{
    self.searchBar.text = word;
    
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0) 
    {
        self.resultTable.hidden = YES;
        return;
    }
    
    //get associated search result if there's any
    //self.resultArray = search result;
    [self.searchBar becomeFirstResponder];
    
    if(self.resultTable.hidden) self.resultTable.hidden = NO;
    [self.resultTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //get search result
    //self.resultArray = search result;
    
    if(self.resultTable.hidden) self.resultTable.hidden = NO;
    [self.resultTable reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [UIView animateWithDuration:1. delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, 2*self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
                     } 
                     completion:^(BOOL finished){ 
                         
                     }];
}



#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";  
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];  //在subtitle中显示分类描述
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    if (indexPath.row != self.resultArray.count) 
    {
        cell.textLabel.text = @"search result here"; //[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor blackColor];
    } 

    
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectOnResult:)]) 
    {
        [self.delegate selectOnResult:[self.resultArray objectAtIndex:indexPath.row]];
    }

}


@end

#define MARGIN 10
#define TOPMARGIN 44
@implementation HotKeyWordsView
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240./256 green:240./256 blue:240./256 alpha:1.f];
        
        UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)] autorelease];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.text = @"Popular searches"; 
        textLabel.textColor = [UIColor colorWithRed:90./256 green:90./256 blue:90./256 alpha:1];
        textLabel.font = [UIFont fontWithName:@"Arial" size:15];
        textLabel.shadowColor = [UIColor whiteColor];
        textLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:textLabel];
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (void)setKeyWords:(NSArray *)words
{
    int i = 0;
    CGRect frameOfLastButton = CGRectZero;
    
    for(NSDictionary *dict in words)
    {
        UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(10, TOPMARGIN+i*(5+20) , 70, 20)] autorelease];
        label.text = [dict objectForKey:@"name"];
        label.textColor = [UIColor colorWithRed:149./256 green:149./256 blue:149./256 alpha:1];  
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont fontWithName:@"GillSans" size:16]];
        
        int j = 0;
        for (NSString *word in [dict objectForKey:@"words"])
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:word forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:66./256 green:116./256 blue:205./256 alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"GillSans" size:14];
            [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0, 1);
            CGSize size = [word sizeWithFont:[UIFont systemFontOfSize:14]];
            if(j!=0) button.frame = CGRectMake(frameOfLastButton.origin.x + frameOfLastButton.size.width + MARGIN, TOPMARGIN+i*(5+20) , size.width, size.height); 
            else button.frame = CGRectMake(70, TOPMARGIN+i*(5+20), size.width, size.height);
            [self addSubview:button];
                        
            [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            
            j++;
            frameOfLastButton = button.frame;
        }
        
        i++;
        frameOfLastButton = CGRectZero;
    }
    
}

- (void)buttonPress:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(selectOnKeyWord:)]) 
    {
        [self.delegate selectOnKeyWord:sender.titleLabel.text];
    }
}

@end
