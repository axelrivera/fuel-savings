//
//  TripViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/1/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "DetailSummaryView.h"
#import "CurrentTripViewController.h"
#import "NameInputViewController.h"
#import "DetailSummaryView.h"

@interface TripViewController : UIViewController
<UIActionSheetDelegate, CurrentTripViewControllerDelegate, NameInputViewControllerDelegate>
{
	SavingsData *savingsData_;
	BOOL isNewTrip_;
	BOOL showNewAction_;
	BOOL hasButtons_;
}

@property (nonatomic, retain) IBOutlet UITableView *tripTable;
@property (nonatomic, retain) IBOutlet UILabel *instructionsLabel;
@property (nonatomic, copy) Trip *currentTrip;

- (id)initWithTabBar:(BOOL)tab buttons:(BOOL)buttons;

- (void)saveCurrentTrip:(Trip *)trip;
- (void)reloadTable;

@end
