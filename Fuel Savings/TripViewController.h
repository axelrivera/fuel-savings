//
//  TripViewController.h
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripData.h"
#import "CurrentTripViewController.h"
#import "NameInputViewController.h"

@interface TripViewController : UITableViewController <UIActionSheetDelegate, CurrentTripViewControllerDelegate,
	NameInputViewControllerDelegate>
{
    TripData *tripData_;
	NSNumberFormatter *currencyFormatter_;
	BOOL isNewTrip_;
	BOOL showNewAction_;
	BOOL hasTabBar_;
}

@property (nonatomic, retain) Trip *tripCalculation;
@property (nonatomic, copy) Trip *backupCopy;

- (id)initWithTabBar;

@end
