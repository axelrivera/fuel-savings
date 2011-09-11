//
//  FuelSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "CurrentSavingsViewController.h"
#import "SavingsData.h"
#import "Savings.h"
#import "DetailSummaryView.h"
#import "NameInputViewController.h"

@interface FuelSavingsViewController : UIViewController <UIActionSheetDelegate, CurrentSavingsViewControllerDelegate,
NameInputViewControllerDelegate, ADBannerViewDelegate>
{
	SavingsData *savingsData_;
	BOOL isNewSavings_;
	BOOL showNewAction_;
	BOOL hasButtons_;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *savingsTable;
@property (nonatomic, retain) IBOutlet UILabel *instructionsLabel;
@property (nonatomic, copy) Savings *currentSavings;

- (id)initWithTabBar:(BOOL)tab buttons:(BOOL)buttons;

- (void)saveCurrentSavings:(Savings *)savings;
- (void)reloadTable;

@end
