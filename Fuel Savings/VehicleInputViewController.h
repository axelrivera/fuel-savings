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

@interface VehicleInputViewController : UITableViewController <UITextFieldDelegate> {
	SavingsData *savingsData_;
	UITextField *nameTextField_;
	UITextField *avgTextField_;
	UITextField *cityTextField_;
	UITextField *highwayTextField_;
	NSInteger infoRows_;
	Vehicle *editingVehicle_;
}

@property (nonatomic, copy) NSString *vehicleName;

- (void)setEditingVehicle:(Vehicle *)vehicle;

@end
