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
#import "DetailSummaryView.h"
#import "NameInputViewController.h"
#import <iAd/iAd.h>

@interface FuelSavingsViewController : UIViewController <UIActionSheetDelegate, CurrentSavingsViewControllerDelegate,
	NameInputViewControllerDelegate, ADBannerViewDelegate>
{
	SavingsData *savingsData_;
	BOOL isNewSavings_;
	BOOL showNewAction_;
	BOOL hasButtons_;
	ADBannerView *adBanner_;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *savingsTable;
@property (nonatomic, retain) IBOutlet UILabel *instructionsLabel;
@property (nonatomic, copy) Savings *currentSavings;
@property (nonatomic, retain) DetailSummaryView *infoSummary;
@property (nonatomic, retain) DetailSummaryView *car1Summary;
@property (nonatomic, retain) DetailSummaryView *car2Summary;
@property (nonatomic, copy) NSString *currentCountry;

- (id)initWithTabBar:(BOOL)tab buttons:(BOOL)buttons;

- (void)saveCurrentSavings:(Savings *)savings;
- (void)reloadTable;

@end
