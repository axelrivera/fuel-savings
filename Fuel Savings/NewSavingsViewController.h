//
//  CurrentSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "SavingsCalculation.h"
#import "TypeInputViewController.h"
#import "PriceInputViewController.h"
#import "DistanceInputViewController.h"
#import "RatioInputViewController.h"
#import "OwnerInputViewController.h"
#import "NameInputViewController.h"
#import "EfficiencyInputViewController.h"

@protocol NewSavingsViewControllerDelegate;

@interface NewSavingsViewController : UIViewController
	<TypeInputViewControllerDelegate,PriceInputViewControllerDelegate,DistanceInputViewControllerDelegate,
	RatioInputViewControllerDelegate,OwnerInputViewControllerDelegate,NameInputViewControllerDelegate,
	EfficiencyInputViewControllerDelegate>
{
	SavingsData *savingsData_;
	NSMutableArray *newData_;
	NSArray *avgInformationKeys_;
	NSArray *combinedInformationKeys_;
	NSArray *avgVehicleKeys_;
	NSArray *combinedVehicleKeys_;
}

@property (nonatomic, assign) id <NewSavingsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *newTable;

@end

@protocol NewSavingsViewControllerDelegate

- (void)newSavingsViewControllerDelegateDidFinish:(NewSavingsViewController *)controller save:(BOOL)save;

@end
