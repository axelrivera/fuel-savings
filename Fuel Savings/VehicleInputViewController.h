//
//  VehicleInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "Vehicle.h"
#import "NameInputViewController.h"
#import "EfficiencyInputViewController.h"

@protocol VehicleInputViewControllerDelegate;

@interface VehicleInputViewController : UITableViewController
	<NameInputViewControllerDelegate, EfficiencyInputViewControllerDelegate>
{
	SavingsData *savingsData_;
	NSInteger infoRows_;
}

@property (nonatomic, assign) id <VehicleInputViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *currentName;
@property (nonatomic, copy) NSNumber *currentAvgEfficiency;
@property (nonatomic, copy) NSNumber *currentCityEfficiency;
@property (nonatomic, copy) NSNumber *currentHighwayEfficiency;
@property (nonatomic) BOOL isEditingVehicle;

@end

@protocol VehicleInputViewControllerDelegate

- (void)vehicleInputViewControllerDidFinish:(VehicleInputViewController *)controller save:(BOOL)save;

@end
