//
//  MySavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "NameInputViewController.h"

@interface MySavingsViewController : UITableViewController <NameInputViewControllerDelegate, UIActionSheetDelegate> {
	SavingsData *savingsData_;
    NSMutableArray *tableData_;
	NSInteger selectedIndex_;
}

@property (nonatomic, retain) UISegmentedControl *segmentedControl;

- (id)initWithTabBar;

@end
