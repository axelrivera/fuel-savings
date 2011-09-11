//
//  TripViewController+Details.h
//  Fuel Savings
//
//  Created by Axel Rivera on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TripViewController.h"
#import "TotalView.h"
#import "DetailSummaryView.h"

@interface TripViewController (TripViewController_Details)

- (TotalView *)tripCostView;

- (DetailSummaryView *)infoSummaryView;
- (DetailSummaryView *)carSummaryView;

- (NSArray *)infoDetails;
- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle;

@end
