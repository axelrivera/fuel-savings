//
//  MySavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameInputViewController.h"
#import <iAd/iAd.h>

@interface MySavingsViewController : UIViewController <NameInputViewControllerDelegate, UIActionSheetDelegate, ADBannerViewDelegate> {
	NSInteger selectedRow_;
	NSInteger selectedIndex_;
	ADBannerView *adBanner_;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *mySavingsTable;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) NSMutableArray *tableData;

- (id)initWithTabBar;

@end
