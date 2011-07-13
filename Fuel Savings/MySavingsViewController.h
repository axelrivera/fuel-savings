//
//  MySavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"

@interface MySavingsViewController : UITableViewController {
	SavingsData *savingsData_;
    NSMutableArray *tableData_;
}

@property (nonatomic, retain) UISegmentedControl *segmentedControl;

- (id)initWithTabBar;

@end
