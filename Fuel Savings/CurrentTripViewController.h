//
//  CurrentTripViewController.h
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Trip.h"
#import "PriceInputViewController.h"
#import "DistanceInputViewController.h"
#import "NameInputViewController.h"
#import "EfficiencyInputViewController.h"
#import "VehicleDetailsViewController.h"

@protocol CurrentTripViewControllerDelegate;

@interface CurrentTripViewController : UIViewController
<PriceInputViewControllerDelegate, DistanceInputViewControllerDelegate, NameInputViewControllerDelegate,
EfficiencyInputViewControllerDelegate, VehicleDetailsViewControllerDelegate, ADBannerViewDelegate>

@property (nonatomic, assign) id <CurrentTripViewControllerDelegate> delegate;
@property (nonatomic, retain) Trip *currentTrip;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *newTable;
@property (nonatomic, retain) NSMutableArray *newData;
@property (nonatomic, assign) BOOL isEditingTrip;

- (id)initWithTrip:(Trip *)trip;

@end

@protocol CurrentTripViewControllerDelegate

- (void)currentTripViewControllerDelegateDidFinish:(CurrentTripViewController *)controller save:(BOOL)save;

@end
