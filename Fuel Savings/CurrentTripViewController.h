//
//  CurrentTripViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/15/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "PriceInputViewController.h"
#import "DistanceInputViewController.h"
#import "NameInputViewController.h"
#import "EfficiencyInputViewController.h"
#import "VehicleDetailsViewController.h"

@protocol CurrentTripViewControllerDelegate;

@interface CurrentTripViewController : UIViewController
<PriceInputViewControllerDelegate, DistanceInputViewControllerDelegate, NameInputViewControllerDelegate,
EfficiencyInputViewControllerDelegate, VehicleDetailsViewControllerDelegate>

@property (nonatomic, assign) id <CurrentTripViewControllerDelegate> delegate;
@property (nonatomic, retain) Trip *currentTrip;
@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *myData;
@property (nonatomic, assign) BOOL isEditingTrip;

- (id)initWithTrip:(Trip *)trip;

@end

@protocol CurrentTripViewControllerDelegate

- (void)currentTripViewControllerDelegateDidFinish:(CurrentTripViewController *)controller save:(BOOL)save;

@end
