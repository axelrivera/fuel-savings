//
//  FuelSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentSavingsViewController.h"
#import "SavingsData.h"
#import "Savings.h"
#import "NameInputViewController.h"

@interface FuelSavingsViewController : UITableViewController <UIActionSheetDelegate, CurrentSavingsViewControllerDelegate,
	NameInputViewControllerDelegate>
{
	SavingsData *savingsData_;
	NSNumberFormatter *currencyFormatter_;
	UIView *annualFooterView_;
	UIView *totalFooterView_;
	UIView *infoFooterView_;
	BOOL isNewSavings_;
	BOOL showNewAction_;
	BOOL hasTabBar_;
}

@property (nonatomic, copy) NSNumber *vehicle1AnnualCost;
@property (nonatomic, copy) NSNumber *vehicle1TotalCost;
@property (nonatomic, copy) NSNumber *vehicle2AnnualCost;
@property (nonatomic, copy) NSNumber *vehicle2TotalCost;
@property (nonatomic, retain) Savings *savingsCalculation;
@property (nonatomic, copy) Savings *backupCopy;

- (id)initWithTabBar;

@end
