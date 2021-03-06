//
//  VehicleSelectViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class CurrentSavingsViewController;
@class CurrentTripViewController;

typedef enum {
	VehicleSelectionTypeYear,
	VehicleSelectionTypeMake,
	VehicleSelectionTypeModel
} VehicleSelectionType;

@interface VehicleSelectViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITableView *selectionTable;
@property (nonatomic, assign) VehicleSelectionType selectionType;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *make;
@property (nonatomic, retain) NSArray *mpgDatabaseInfo;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, assign) CurrentSavingsViewController *currentSavingsViewController;
@property (nonatomic, assign) CurrentTripViewController *currentTripViewController;

- (id)initWithType:(VehicleSelectionType)type year:(NSString *)year make:(NSString *)make;
- (id)initWithTabBar;

@end
