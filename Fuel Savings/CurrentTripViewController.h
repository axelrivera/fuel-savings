//
//  CurrentTripViewController.h
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripData.h"
#import "Trip.h"
#import "PriceInputViewController.h"
#import "NameInputViewController.h"
#import "EfficiencyInputViewController.h"

@protocol CurrentTripViewControllerDelegate;

@interface CurrentTripViewController : UITableViewController {
    
}

@property (nonatomic, assign) id <CurrentTripViewControllerDelegate> delegate;
@property (nonatomic) BOOL isEditingTrip;

@end

@protocol CurrentTripViewControllerDelegate

- (void)currentTripViewControllerDelegateDidFinish:(CurrentTripViewController *)controller save:(BOOL)save;

@end
