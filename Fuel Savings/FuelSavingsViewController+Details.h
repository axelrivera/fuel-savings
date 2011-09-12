//
//  FuelSavingsViewController+Details.h
//  Fuel Savings
//
//  Created by Axel Rivera on 9/9/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "TotalView.h"
#import "DetailSummaryView.h"

@interface FuelSavingsViewController (FuelSavingsViewController_Details)

- (TotalView *)annualFuelCostView;
- (TotalView *)totalFuelCostView;

- (DetailSummaryView *)infoSummaryView;
- (DetailSummaryView *)car1SummaryView;
- (DetailSummaryView *)car2SummaryView;


- (NSArray *)infoDetails;
- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle;

@end
