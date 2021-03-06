//
//  MySavingsViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameInputViewController.h"

@interface MySavingsViewController : UIViewController <NameInputViewControllerDelegate> {
	NSInteger selectedRow_;
	NSInteger selectedIndex_;
}

@property (nonatomic, retain) IBOutlet UITableView *mySavingsTable;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) NSMutableArray *tableData;

- (id)initWithTabBar;

@end
