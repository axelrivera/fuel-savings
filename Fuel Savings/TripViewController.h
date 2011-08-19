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
#import "DetailSummaryView.h"
#import "DoubleButtonView.h"

@interface TripViewController : UIViewController <UIActionSheetDelegate, CurrentTripViewControllerDelegate,
	NameInputViewControllerDelegate>
{
    SavingsData *savingsData_;
	BOOL isNewTrip_;
	BOOL showNewAction_;
	DoubleButtonView *buttonView_;
}

@property (nonatomic, retain) IBOutlet UITableView *tripTable;
@property (nonatomic, retain) IBOutlet UILabel *instructionsLabel;
@property (nonatomic, copy) Trip *currentTrip;
@property (nonatomic, retain) DetailSummaryView *infoSummary;
@property (nonatomic, retain) DetailSummaryView *carSummary;
@property (nonatomic, copy) NSString *currentCountry;

- (id)initWithTabBar;

- (void)saveCurrentTrip:(Trip *)trip;
- (void)reloadTable;

@end
