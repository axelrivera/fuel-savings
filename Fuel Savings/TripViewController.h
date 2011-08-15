//
//  TripViewController.h
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "DetailSummaryView.h"
#import "CurrentTripViewController.h"
#import "NameInputViewController.h"

@interface TripViewController : UITableViewController <UIActionSheetDelegate, CurrentTripViewControllerDelegate,
	NameInputViewControllerDelegate>
{
    SavingsData *savingsData_;
	NSNumberFormatter *currencyFormatter_;
	BOOL isNewTrip_;
	BOOL showNewAction_;
}

@property (nonatomic, assign) BOOL showButtons;
@property (nonatomic, copy) Trip *newTrip;
@property (nonatomic, copy) Trip *currentTrip;

- (id)initWithTabBar;

- (void)saveCurrentTrip:(Trip *)trip;

@end
