//
//  TripViewController.h
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "CurrentTripViewController.h"
#import "NameInputViewController.h"

@interface TripViewController : UITableViewController <UIActionSheetDelegate, CurrentTripViewControllerDelegate,
	NameInputViewControllerDelegate>
{
    SavingsData *savingsData_;
	NSNumberFormatter *currencyFormatter_;
	BOOL isNewTrip_;
	BOOL showNewAction_;
	BOOL hasTabBar_;
}

@property (nonatomic, copy) Trip *newTrip;
@property (nonatomic, copy) Trip *currentTrip;

- (id)initWithTabBar;

@end
