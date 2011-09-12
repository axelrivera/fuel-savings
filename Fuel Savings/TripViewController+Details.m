//
//  TripViewController+Details.m
//  Fuel Savings
//
//  Created by Axel Rivera on 9/11/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "TripViewController+Details.h"
#import "DetailView.h"

@implementation TripViewController (TripViewController_Details)

- (TotalView *)tripCostView
{
	TotalView *tripView = [[[TotalView alloc] initWithFrame:CGRectZero] autorelease];
	tripView.imageView.image = [UIImage imageNamed:@"money.png"];
	tripView.titleLabel.text = @"Trip Cost";
	tripView.text1Label.text = [self.currentTrip stringForName];
	tripView.detail1Label.text = [self.currentTrip stringForTripCost];
	
	UIColor *textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
	
	tripView.text1Label.textColor = textColor;
	tripView.detail1Label.textColor = textColor;
	
	return tripView;
}

- (DetailSummaryView *)infoSummaryView
{
	DetailSummaryView *infoView = [[[DetailSummaryView alloc] initWithDetails:[self infoDetails]] autorelease];
	infoView.titleLabel.text = @"Details";
	infoView.imageView.image = [UIImage imageNamed:@"details.png"];
	return infoView;
}

- (DetailSummaryView *)carSummaryView
{
	DetailSummaryView *carView = [[[DetailSummaryView alloc] initWithDetails:
								  [self carDetailsForVehicle:self.currentTrip.vehicle]] autorelease];
	carView.titleLabel.text = kTripDefaultVehicleName;
	carView.imageView.image = [UIImage imageNamed:@"car.png"];
	return carView;
}

- (NSArray *)infoDetails
{
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	[details addObject:[DetailView detailDictionaryWithText:@"Trip Name" detail:[self.currentTrip stringForName]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Distance" detail:[self.currentTrip stringForDistance]]];
	return details;
}

- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle
{	
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	[details addObject:[DetailView detailDictionaryWithText:@"Name" detail:[vehicle stringForName]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Fuel Price" detail:[self.currentTrip.vehicle stringForFuelPrice]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Fuel Efficiency" detail:[vehicle stringForAvgEfficiency]]];
	return details;
}

@end
