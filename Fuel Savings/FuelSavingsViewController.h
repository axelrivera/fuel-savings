//
//  FuelSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLTopToolbar.h"
#import "NewSavingsViewController.h"
#import "SavingsData.h"

@interface FuelSavingsViewController : UIViewController <NewSavingsViewControllerDelegate> {
	SavingsData *savingsData_;
	NSNumberFormatter *currencyFormatter_;
	UILabel *annualFooterView_;
	UILabel *totalFooterView_;
}

@property (nonatomic, retain) IBOutlet UITableView *savingsTable;
@property (nonatomic, copy) NSNumber *vehicle1AnnualCost;
@property (nonatomic, copy) NSNumber *vehicle1TotalCost;
@property (nonatomic, copy) NSNumber *vehicle2AnnualCost;
@property (nonatomic, copy) NSNumber *vehicle2TotalCost;

- (id)initWithTabBar;

@end
