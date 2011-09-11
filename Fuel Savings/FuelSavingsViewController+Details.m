//
//  FuelSavingsViewController+Details.m
//  Fuel Savings
//
//  Created by Axel Rivera on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController+Details.h"
#import "DetailView.h"

@implementation FuelSavingsViewController (FuelSavingsViewController_Details)

- (TotalView *)annualFuelCostView
{
	TotalView *annualView = [[[TotalView alloc] initWithFrame:CGRectZero] autorelease];
	
	annualView.imageView.image = [UIImage imageNamed:@"money.png"];
	annualView.titleLabel.text = @"Annual Fuel Cost";
	
	annualView.text1Label.text = [self.currentSavings.vehicle1 stringForName];
	annualView.detail1Label.text = [self.currentSavings stringForAnnualCostForVehicle1];
	
	if ([self.currentSavings.vehicle2 hasDataReady]) {
		annualView.text2Label.hidden = NO;
		annualView.detail2Label.hidden = NO;
		annualView.text2Label.text = [self.currentSavings.vehicle2 stringForName];
		annualView.detail2Label.text = [self.currentSavings stringForAnnualCostForVehicle2];
		NSComparisonResult compareCost;
		compareCost = [[self.currentSavings annualCostForVehicle1] compare:[self.currentSavings annualCostForVehicle2]];
		UIColor *highlightColor = [UIColor colorWithRed:245.0/255.0 green:121.0/255.0 blue:0.0 alpha:1.0];
		
		if (compareCost == NSOrderedAscending) {
			annualView.text1Label.textColor = highlightColor;
			annualView.detail1Label.textColor = highlightColor;
		} else if (compareCost == NSOrderedDescending) {
			annualView.text2Label.textColor = highlightColor;
			annualView.detail2Label.textColor = highlightColor;
		}
	}
	return annualView;
}

- (TotalView *)totalFuelCostView
{
	TotalView *totalView = [[[TotalView alloc] initWithFrame:CGRectZero] autorelease];
	
	totalView.imageView.image = [UIImage imageNamed:@"chart.png"];
	totalView.titleLabel.text = @"Total Fuel Cost";
	
	totalView.text1Label.text = [self.currentSavings.vehicle1 stringForName];
	totalView.detail1Label.text = [self.currentSavings stringForTotalCostForVehicle1];
	
	if ([self.currentSavings.vehicle2 hasDataReady]) {
		totalView.text2Label.hidden = NO;
		totalView.detail2Label.hidden = NO;
		totalView.text2Label.text = [self.currentSavings.vehicle2 stringForName];
		totalView.detail2Label.text = [self.currentSavings stringForTotalCostForVehicle2];
		NSComparisonResult compareCost;
		compareCost = [[self.currentSavings totalCostForVehicle1] compare:[self.currentSavings totalCostForVehicle2]];
		UIColor *highlightColor = [UIColor colorWithRed:245.0/255.0 green:121.0/255.0 blue:0.0 alpha:1.0];
		
		if (compareCost == NSOrderedAscending) {
			totalView.text1Label.textColor = highlightColor;
			totalView.detail1Label.textColor = highlightColor;
		} else if (compareCost == NSOrderedDescending) {
			totalView.text2Label.textColor = highlightColor;
			totalView.detail2Label.textColor = highlightColor;
		}
	}
	return totalView;
}

- (DetailSummaryView *)infoSummaryView
{
	DetailSummaryView *infoView = [[[DetailSummaryView alloc] initWithDetails:[self infoDetails]] autorelease];
	infoView.titleLabel.text = @"Details";
	infoView.imageView.image = [UIImage imageNamed:@"details.png"];
	return infoView;
}

- (DetailSummaryView *)car1SummaryView
{
	DetailSummaryView *car1View = [[[DetailSummaryView alloc] initWithDetails:
								   [self carDetailsForVehicle:self.currentSavings.vehicle1]] autorelease];
	car1View.titleLabel.text = kSavingsVehicle1DefaultName;
	car1View.imageView.image = [UIImage imageNamed:@"car.png"];
	return car1View;
}

- (DetailSummaryView *)car2SummaryView
{
	DetailSummaryView *car2View = [[[DetailSummaryView alloc] initWithDetails:
								   [self carDetailsForVehicle:self.currentSavings.vehicle2]] autorelease];
	car2View.titleLabel.text = kSavingsVehicle2DefaultName;
	car2View.imageView.image = [UIImage imageNamed:@"car.png"];
	return car2View;
}

- (NSArray *)infoDetails
{
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	[details addObject:[DetailView detailDictionaryWithText:@"Using" detail:[self.currentSavings stringForCurrentType]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Distance" detail:[self.currentSavings stringForDistance]]];
	
	if (self.currentSavings.type == EfficiencyTypeCombined) {
		[details addObject:[DetailView detailDictionaryWithText:@"City Drive Ratio" detail:[self.currentSavings stringForCityRatio]]];
		[details addObject:[DetailView detailDictionaryWithText:@"Highway Drive Ratio" detail:[self.currentSavings stringForHighwayRatio]]];
	}
	
	[details addObject:[DetailView detailDictionaryWithText:@"Ownership" detail:[self.currentSavings stringForCarOwnership]]];
	
	return details;
}

- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle
{	
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	[details addObject:[DetailView detailDictionaryWithText:@"Name" detail:[vehicle stringForName]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Fuel Price" detail:[vehicle stringForFuelPrice]]];
	
	if (self.currentSavings.type == EfficiencyTypeAverage) {
		[details addObject:[DetailView detailDictionaryWithText:@"Average MPG" detail:[vehicle stringForAvgEfficiency]]];
	} else {
		[details addObject:[DetailView detailDictionaryWithText:@"City MPG" detail:[vehicle stringForCityEfficiency]]];
		[details addObject:[DetailView detailDictionaryWithText:@"Highway MPG" detail:[vehicle stringForHighwayEfficiency]]];
	}
	
	return details;
}

@end
