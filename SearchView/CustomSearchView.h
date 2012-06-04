//
//  CustomSearchView.h
//  NightShow
//
//  Created by B.H. Liu on 12-5-23.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSearchView;

@protocol SearchViewDelegate <NSObject>

-(void)selectOnResult:(NSDictionary *)result;

@end

@interface CustomSearchView : UIView <UISearchBarDelegate>

@property (nonatomic, retain) UISearchBar * searchBar;
@property (nonatomic, assign) id<SearchViewDelegate>delegate;
- (void)reloadData;

@end

@protocol KeyWordDelegate <NSObject>

- (void)selectOnKeyWord:(NSString*)word;

@end

@class HotKeyWordsView;

@interface HotKeyWordsView : UIView

@property (nonatomic,assign) id<KeyWordDelegate>delegate;
- (void)setKeyWords:(NSArray*)words;

@end
