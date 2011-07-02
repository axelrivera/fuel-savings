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
#import "OwnerInputViewController.h"
#import "VehicleInputViewController.h"

@interface CurrentSavingsViewController : UIViewController
	<TypeInputViewControllerDelegate, PriceInputViewControllerDelegate, DistanceInputViewControllerDelegate,
	OwnerInputViewControllerDelegate, VehicleInputViewControllerDelegate>
{
	SavingsData *savingsData_;
}

@property (nonatomic, retain) IBOutlet UITableView *currentTable;

@end
