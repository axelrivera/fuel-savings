//
//  CurrentSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "Savings.h"
#import "TypeInputViewController.h"
#import "PriceInputViewController.h"
#import "DistanceInputViewController.h"
#import "OwnerInputViewController.h"
#import "NameInputViewController.h"
#import "EfficiencyInputViewController.h"
#import "VehicleSelectViewController.h"
#import "VehicleDetailsViewController.h"
#include <iAd/iAd.h>

@protocol CurrentSavingsViewControllerDelegate;

@interface CurrentSavingsViewController : UIViewController
<UIActionSheetDelegate, TypeInputViewControllerDelegate, PriceInputViewControllerDelegate, DistanceInputViewControllerDelegate,
OwnerInputViewControllerDelegate, NameInputViewControllerDelegate, EfficiencyInputViewControllerDelegate,
VehicleDetailsViewControllerDelegate, ADBannerViewDelegate>
{
	BOOL isCar1Selected_;
	BOOL isCar2Selected_;
	ADBannerView *adBanner_;
}

@property (nonatomic, assign) id <CurrentSavingsViewControllerDelegate> delegate;
@property (nonatomic, retain) Savings *currentSavings;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *newTable;
@property (nonatomic, retain) NSMutableArray *newData;
@property (nonatomic) BOOL isEditingSavings;

- (id)initWithSavings:(Savings *)savings;

@end

@protocol CurrentSavingsViewControllerDelegate

- (void)currentSavingsViewControllerDelegateDidFinish:(CurrentSavingsViewController *)controller save:(BOOL)save;

@end
