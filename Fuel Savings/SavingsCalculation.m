//
//  SavingsCalculation.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsCalculation.h"

@interface SavingsCalculation (Private)

- (NSNumber *)annualCostForVehicle:(Vehicle *)vehicle;
- (NSNumber *)lifeCostForVehicle:(Vehicle *)vehicle;

@end

@implementation SavingsCalculation

@synthesize name = name_;
@synthesize type;
@synthesize fuelPrice = fuelPrice_;
@synthesize cityRatio = cityRatio_;
@synthesize highwayRatio = highwayRatio_;
@synthesize distance = distance_;
@synthesize carOwnership = carOwnership_;
@synthesize vehicle1 = vehicle1_;
@synthesize vehicle2 = vehicle2_;

#pragma mark - Class Methods

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
		self.type = SavingsCalculationTypeAverage;
		self.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"3.65"];
		// The cityRatio Setter will also set highwayRatio
		self.cityRatio = [NSNumber numberWithFloat:0.55];
		self.distance = [NSNumber numberWithInteger:15000];
		self.carOwnership = [NSNumber numberWithInteger:5];
		self.vehicle1 = [Vehicle vehicleWithName:@"Car 1"];
		self.vehicle2 = [Vehicle vehicleWithName:@"Car 2"];
	}
	return self;
}

- (void)dealloc
{
	[name_ release];
	[fuelPrice_ release];
	[distance_ release];
	[carOwnership_ release];
	[vehicle1_ release];
	[vehicle2_ release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	SavingsCalculation *newSavings = [[[self class] allocWithZone:zone] init];
	newSavings.name = self.name;
	newSavings.type = self.type;
	newSavings.fuelPrice = self.fuelPrice;
	newSavings.distance = self.distance;
	newSavings.carOwnership = self.carOwnership;
	newSavings.vehicle1 = self.vehicle1;
	newSavings.vehicle2 = self.vehicle2;
	return newSavings;
}

#pragma mark - Custom Methods

+ (NSString *)stringValueForType:(SavingsCalculationType)type
{
	if (type == SavingsCalculationTypeAverage) {
		return @"Average MPG";
	}
	return @"City / Highway MPG";
}

- (NSString *)stringForCurrentType
{
	return [[self class] stringValueForType:self.type];
}

- (NSNumber *)annualCostForVehicle1
{
	return [self annualCostForVehicle:self.vehicle1];
}

- (NSNumber *)lifeCostForVehicle1
{
	return [self lifeCostForVehicle:self.vehicle1];
}

- (NSNumber *)annualCostForVehicle2
{
	return [self annualCostForVehicle:self.vehicle2];
}

- (NSNumber *)lifeCostForVehicle2
{
	return [self annualCostForVehicle:self.vehicle2];
}

#pragma mark - Custom Setters

- (void)setCityRatio:(NSNumber *)ratio
{
	NSAssert([ratio floatValue] <= 1.0, @"Invalid Ratio");
	if (cityRatio_ != nil) {
		[cityRatio_ release];
	}
	cityRatio_ = [ratio copy];
	
	if (highwayRatio_ != nil) {
		[highwayRatio_ release];
	}
	highwayRatio_  = [[NSNumber alloc] initWithFloat:1 - [ratio floatValue]];
}

- (void)setHighwayRatio:(NSNumber *)ratio
{
	NSAssert([ratio floatValue] <= 1.0, @"Invalid Ratio");
	if (highwayRatio_ != nil) {
		[highwayRatio_ release];
	}
	highwayRatio_ = [ratio copy];
	
	if (cityRatio_ != nil) {
		[cityRatio_ release];
	}
	cityRatio_ = [[NSNumber alloc] initWithFloat:1 - [ratio floatValue]];
}

#pragma mark - Private Methods

- (NSNumber *)annualCostForVehicle:(Vehicle *)vehicle
{
	return [NSNumber numberWithInteger:0];
}

- (NSNumber *)lifeCostForVehicle:(Vehicle *)vehicle
{
	return [NSNumber numberWithInteger:0];
}

@end
