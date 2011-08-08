//
//  Savings.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Savings.h"

@interface Savings (Private)

- (NSNumber *)annualCostForVehicle:(Vehicle *)vehicle;
- (NSNumber *)totalCostForVehicle:(Vehicle *)vehicle;

@end

@implementation Savings

@synthesize name = name_;
@synthesize type;
@synthesize fuelPrice = fuelPrice_;
@synthesize cityRatio = cityRatio_;
@synthesize highwayRatio = highwayRatio_;
@synthesize distance = distance_;
@synthesize carOwnership = carOwnership_;
@synthesize vehicle1 = vehicle1_;
@synthesize vehicle2 = vehicle2_;

+ (id)calculation
{
	return [[[Savings alloc] init] autorelease];
}

#pragma mark - Class Methods

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
		self.type = EfficiencyTypeAverage;
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

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init]; // this needs to be [super initWithCoder:decoder] if the superclass implements NSCoding
	if (self) {
		self.name = [decoder decodeObjectForKey:@"savingsName"];
		self.type = [decoder decodeIntForKey:@"savingsType"];
		self.fuelPrice = [decoder decodeObjectForKey:@"savingsFuelPrice"];
		self.cityRatio = [decoder decodeObjectForKey:@"savingsCityRatio"];
		self.distance = [decoder decodeObjectForKey:@"savingsDistance"];
		self.carOwnership = [decoder decodeObjectForKey:@"savingsCarOwnership"];
		self.vehicle1 = [decoder decodeObjectForKey:@"savingsVehicle1"];
		self.vehicle2 = [decoder decodeObjectForKey:@"savingsVehicle2"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.name forKey:@"savingsName"];
	[encoder encodeInt:self.type forKey:@"savingsType"];
	[encoder encodeObject:self.fuelPrice forKey:@"savingsFuelPrice"];
	[encoder encodeObject:self.cityRatio forKey:@"savingsCityRatio"];
	[encoder encodeObject:self.distance forKey:@"savingsDistance"];
	[encoder encodeObject:self.carOwnership forKey:@"savingsCarOwnership"];
	[encoder encodeObject:self.vehicle1 forKey:@"savingsVehicle1"];
	[encoder encodeObject:self.vehicle2 forKey:@"savingsVehicle2"];
}

- (id)copyWithZone:(NSZone *)zone
{
	Savings *newSavings = [[Savings allocWithZone:zone] init];
	newSavings.name = self.name;
	newSavings.type = self.type;
	newSavings.fuelPrice = self.fuelPrice;
	newSavings.distance = self.distance;
	newSavings.carOwnership = self.carOwnership;
	newSavings.vehicle1 = self.vehicle1;
	newSavings.vehicle2 = self.vehicle2;
	return newSavings;
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

#pragma mark - Custom Methods

- (NSString *)stringForCurrentType
{
	return efficiencyTypeStringValue(self.type);
}

- (NSNumber *)annualCostForVehicle1
{
	return [self annualCostForVehicle:self.vehicle1];
}

- (NSNumber *)totalCostForVehicle1
{
	return [self totalCostForVehicle:self.vehicle1];
}

- (NSNumber *)annualCostForVehicle2
{
	return [self annualCostForVehicle:self.vehicle2];
}

- (NSNumber *)totalCostForVehicle2
{
	return [self totalCostForVehicle:self.vehicle2];
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
	float annual = 0.0;
	if (self.type == EfficiencyTypeAverage) {
		annual = [self.fuelPrice floatValue] * ([self.distance floatValue] / [vehicle.avgEfficiency floatValue]);
	} else {
		annual = ((([self.distance floatValue] / [vehicle.cityEfficiency floatValue]) * 
				   [self.fuelPrice floatValue]) * ([self.cityRatio floatValue])) + 
		((([self.distance floatValue] / [vehicle.highwayEfficiency floatValue]) * [self.fuelPrice floatValue]) * [self.highwayRatio floatValue]);
	}
	return [NSNumber numberWithFloat:annual];
}

- (NSNumber *)totalCostForVehicle:(Vehicle *)vehicle
{
	return [NSNumber numberWithFloat:[self.carOwnership floatValue] * [[self annualCostForVehicle:vehicle] floatValue]];
}

@end
