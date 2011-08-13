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

+ (Savings *)calculation
{
	return [[[Savings alloc] init] autorelease];
}

+ (Savings *)emptySavings
{
	Savings *savings = [Savings calculation];
	savings.name = @"";
	savings.type = EfficiencyTypeNone;
	savings.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
	savings.cityRatio = [NSNumber numberWithFloat:0.0];
	savings.highwayRatio = [NSNumber numberWithFloat:0.0];
	savings.distance = [NSNumber numberWithInteger:0];
	savings.carOwnership = [NSNumber numberWithInteger:0];
	savings.vehicle1 = [Vehicle emptyVehicle];
	savings.vehicle2 = [Vehicle emptyVehicle];
	return savings;
}


- (id)init
{
	self = [super init];
	if (self) {
		[self setDefaultValues];
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
		self.highwayRatio = [decoder decodeObjectForKey:@"savingsHighwayRatio"];
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
	[encoder encodeObject:self.highwayRatio forKey:@"savingsHighwayRatio"];
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
	newSavings.cityRatio = self.cityRatio;
	newSavings.highwayRatio = self.highwayRatio;
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
	[cityRatio_ release];
	[highwayRatio_ release];
	[distance_ release];
	[carOwnership_ release];
	[vehicle1_ release];
	[vehicle2_ release];
	[super dealloc];
}

#pragma mark - Custom Methods

- (NSString *)stringForName
{
	return self.name;
}

- (NSString *)stringForCurrentType
{
	return efficiencyTypeStringValue(self.type);
}

- (NSString *)stringForFuelPrice
{
	NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSString *priceStr = [priceFormatter stringFromNumber:self.fuelPrice];
	[priceFormatter release];
	
	return [NSString stringWithFormat:@"%@ /gallon", priceStr];
}

- (NSString *)stringForCityRatio
{
	NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc] init];
	[percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
	[percentFormatter setMaximumFractionDigits:0];
	
	NSString *cityStr = [percentFormatter stringFromNumber:self.cityRatio];
	[percentFormatter release];
	
	return cityStr;
}

- (NSString *)stringForHighwayRatio
{
	NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc] init];
	[percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
	[percentFormatter setMaximumFractionDigits:0];
	
	NSString *highwayStr = [percentFormatter stringFromNumber:self.highwayRatio];
	[percentFormatter release];
	
	return highwayStr;
}

- (NSString *)stringForDistance
{
	NSNumberFormatter *distanceFormatter = [[NSNumberFormatter alloc] init];
	[distanceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[distanceFormatter setMaximumFractionDigits:0];
	
	NSString *distanceStr = [distanceFormatter stringFromNumber:self.distance];
	[distanceFormatter release];
	
	return [NSString stringWithFormat:@"%@ miles/year", distanceStr];
}

- (NSString *)stringForCarOwnership
{
	NSString *ownershipStr = nil;
	
	if ([self.carOwnership integerValue] > 1) {
		ownershipStr = [NSString stringWithFormat:@"%@ years", [self.carOwnership stringValue]];
	} else {
		ownershipStr = [NSString stringWithFormat:@"%@ year", [self.carOwnership stringValue]];					
	}
	
	return ownershipStr;	
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

- (void)setRatioForCity:(NSNumber *)city highway:(NSNumber *)highway
{
	if (city) {
		NSAssert([city floatValue] <= 1.0, @"Invalid City Ratio");
		self.cityRatio = city;
		self.highwayRatio = [NSNumber numberWithFloat:1 - [city floatValue]];
		return;
	}
	
	if (highway) {
		NSAssert([highway floatValue] <= 1.0, @"Invalid Ratio");
		self.highwayRatio = highway;
		self.cityRatio = [NSNumber numberWithFloat:1 - [highway floatValue]];
		return;
	}
}

- (void)setDefaultValues
{
	self.name = @"";
	self.type = EfficiencyTypeAverage;
	self.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"3.65"];
	self.cityRatio = [NSNumber numberWithFloat:0.55];
	self.highwayRatio = [NSNumber numberWithFloat:0.45];
	self.distance = [NSNumber numberWithInteger:15000];
	self.carOwnership = [NSNumber numberWithInteger:5];
	self.vehicle1 = [Vehicle vehicleWithName:@"Car 1"];
	self.vehicle2 = [Vehicle vehicleWithName:@"Car 2"];
}

- (BOOL)isSavingsEmpty
{
	NSInteger nameLength = [self.name length];
	CGFloat fuelValue = [self.fuelPrice floatValue];
	CGFloat cityValue = [self.cityRatio floatValue];
	CGFloat highwayValue = [self.highwayRatio floatValue];
	NSInteger distanceValue = [self.distance integerValue];
	NSInteger ownershipValue = [self.carOwnership integerValue];
	BOOL vehicle1Value = [self.vehicle1 isVehicleEmpty];
	BOOL vehicle2Value = [self.vehicle2 isVehicleEmpty];
	
	if (nameLength == 0 && self.type == EfficiencyTypeNone && fuelValue == 0.0 && cityValue == 0.0 && highwayValue == 0.0 &&
		distanceValue == 0 && ownershipValue == 0 && vehicle1Value == YES && vehicle2Value == YES)
	{
		return YES;
	}
	return NO;
}

- (NSString *)description
{	
	NSString *descriptionStr = [NSString stringWithFormat:@"Name: %@, Type: %@, Price: %@, City Ratio: %@, "
								@"Highway Ratio: %@, Distance: %@, Ownership: %@ Vehicle 1: (%@) Vehicle 2: (%@)",
								self.name,
								[self stringForCurrentType],
								[self.fuelPrice stringValue],
								[self.cityRatio stringValue],
								[self.highwayRatio stringValue],
								[self.distance stringValue],
								[self.carOwnership stringValue],
								[self.vehicle1 description],
								[self.vehicle2 description]];
	return descriptionStr;
}

@end
