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
	BOOL isNewSavings_;
	BOOL showNewAction_;
}

@property (nonatomic, assign) BOOL showButtons;
@property (nonatomic, copy) Savings *newSavings;
@property (nonatomic, copy) Savings *currentSavings;

- (id)initWithTabBar;

- (void)saveCurrentSavings:(Savings *)savings;

@end
