//
//  CurrentSavingsViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
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

@protocol CurrentSavingsViewControllerDelegate;

@interface CurrentSavingsViewController : UIViewController
<UIActionSheetDelegate, TypeInputViewControllerDelegate, PriceInputViewControllerDelegate, DistanceInputViewControllerDelegate,
OwnerInputViewControllerDelegate, NameInputViewControllerDelegate, EfficiencyInputViewControllerDelegate,
VehicleDetailsViewControllerDelegate>
{
	BOOL isCar1Selected_;
	BOOL isCar2Selected_;
}

@property (nonatomic, assign) id <CurrentSavingsViewControllerDelegate> delegate;
@property (nonatomic, retain) Savings *currentSavings;
@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *myData;
@property (nonatomic) BOOL isEditingSavings;

- (id)initWithSavings:(Savings *)savings;

@end

@protocol CurrentSavingsViewControllerDelegate

- (void)currentSavingsViewControllerDelegateDidFinish:(CurrentSavingsViewController *)controller save:(BOOL)save;

@end
