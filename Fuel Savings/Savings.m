//
//  Savings.m
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "Savings.h"
#import "NSNumber+Units.h"
#import "Settings.h"

static NSNumberFormatter *percentFormatter_;
static NSNumberFormatter *currencyFormatter_;

@interface Savings (Private)

- (void)setCountry:(NSString *)country;

- (NSNumber *)annualCostForVehicle:(Vehicle *)vehicle;
- (NSNumber *)totalCostForVehicle:(Vehicle *)vehicle;

+ (NSNumberFormatter *)percentFormatter;
+ (NSNumberFormatter *)currencyFormatter;

@end

@implementation Savings

@synthesize name = name_;
@synthesize type;
@synthesize cityRatio = cityRatio_;
@synthesize highwayRatio = highwayRatio_;
@synthesize distance = distance_;
@synthesize carOwnership = carOwnership_;
@synthesize vehicle1 = vehicle1_;
@synthesize vehicle2 = vehicle2_;
@synthesize country = country_;

+ (Savings *)calculation
{
	return [[[Savings alloc] init] autorelease];
}

+ (Savings *)emptySavings
{
	Savings *savings = [Savings calculation];
	savings.name = @"";
	savings.type = EfficiencyTypeNone;
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
		[self setCountry:[Settings sharedSettings].defaultCountry];
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
		self.cityRatio = [decoder decodeObjectForKey:@"savingsCityRatio"];
		self.highwayRatio = [decoder decodeObjectForKey:@"savingsHighwayRatio"];
		self.distance = [decoder decodeObjectForKey:@"savingsDistance"];
		self.carOwnership = [decoder decodeObjectForKey:@"savingsCarOwnership"];
		self.vehicle1 = [decoder decodeObjectForKey:@"savingsVehicle1"];
		self.vehicle2 = [decoder decodeObjectForKey:@"savingsVehicle2"];
		[self setCountry:[decoder decodeObjectForKey:@"savingsCountry"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.name forKey:@"savingsName"];
	[encoder encodeInt:self.type forKey:@"savingsType"];
	[encoder encodeObject:self.cityRatio forKey:@"savingsCityRatio"];
	[encoder encodeObject:self.highwayRatio forKey:@"savingsHighwayRatio"];
	[encoder encodeObject:self.distance forKey:@"savingsDistance"];
	[encoder encodeObject:self.carOwnership forKey:@"savingsCarOwnership"];
	[encoder encodeObject:self.vehicle1 forKey:@"savingsVehicle1"];
	[encoder encodeObject:self.vehicle2 forKey:@"savingsVehicle2"];
	[encoder encodeObject:self.country forKey:@"savingsCountry"];
}

- (id)copyWithZone:(NSZone *)zone
{
	Savings *mySavings = [[Savings allocWithZone:zone] init];
	mySavings.name = self.name;
	mySavings.type = self.type;
	mySavings.cityRatio = self.cityRatio;
	mySavings.highwayRatio = self.highwayRatio;
	mySavings.distance = self.distance;
	mySavings.carOwnership = self.carOwnership;
	mySavings.vehicle1 = self.vehicle1;
	mySavings.vehicle2 = self.vehicle2;
	[mySavings setCountry:self.country];
	return mySavings;
}

- (void)dealloc
{
	[name_ release];
	[cityRatio_ release];
	[highwayRatio_ release];
	[distance_ release];
	[carOwnership_ release];
	[vehicle1_ release];
	[vehicle2_ release];
	[country_ release];
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

- (NSString *)stringForCityRatio
{	
	return [[Savings percentFormatter] stringFromNumber:self.cityRatio];;
}

- (NSString *)stringForHighwayRatio
{
	return [[Savings percentFormatter] stringFromNumber:self.highwayRatio];
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

- (NSString *)stringForAnnualCostForVehicle1
{
	return [[Savings currencyFormatter] stringFromNumber:[self annualCostForVehicle1]];
}

- (NSString *)stringForTotalCostForVehicle1
{
	return [[Savings currencyFormatter] stringFromNumber:[self totalCostForVehicle1]];
}

- (NSString *)stringForAnnualCostForVehicle2
{
	return [[Savings currencyFormatter] stringFromNumber:[self annualCostForVehicle2]];
}

- (NSString *)stringForTotalCostForVehicle2
{
	return [[Savings currencyFormatter] stringFromNumber:[self totalCostForVehicle2]];
}

- (NSString *)annualCostCompareString
{	
	NSString *compareStr = nil;
	
	NSNumber *vehicle1AnnualCost = [self annualCostForVehicle1];
	NSNumber *vehicle2AnnualCost = [self annualCostForVehicle2];
	
	NSComparisonResult result = [vehicle1AnnualCost compare:vehicle2AnnualCost];
	
	if (result == NSOrderedSame) {
		compareStr = @"Fuel cost is the same.";
	} else if (result == NSOrderedDescending) {
		NSNumber *savings = [NSNumber numberWithFloat:[vehicle1AnnualCost floatValue] - [vehicle2AnnualCost floatValue]];
		compareStr = [NSString stringWithFormat:@"%@ saves you %@ each year.",
					  self.vehicle2.name,
					  [[Savings currencyFormatter] stringFromNumber:savings]];
	} else {
		NSNumber *savings = [NSNumber numberWithFloat:[vehicle2AnnualCost floatValue] - [vehicle1AnnualCost floatValue]];
		compareStr = [NSString stringWithFormat:@"%@ saves you %@ each year.",
					  self.vehicle1.name,
					  [[Savings currencyFormatter] stringFromNumber:savings]];
	}
	return compareStr;
}

- (NSString *)totalCostCompareString
{	
	NSString *compareStr = nil;
	NSNumber *vehicle1TotalCost = [self totalCostForVehicle1];
	NSNumber *vehicle2TotalCost = [self totalCostForVehicle2];
	
	NSComparisonResult result = [vehicle1TotalCost compare:vehicle2TotalCost];
	
	NSInteger years = [self.carOwnership integerValue];
	
	if (result == NSOrderedSame) {
		compareStr = [NSString stringWithFormat:@"Fuel cost is the same over %i years.", years];
	} else if (result == NSOrderedDescending) {
		NSNumber *savings = [NSNumber numberWithFloat:[vehicle1TotalCost floatValue] - [vehicle2TotalCost floatValue]];
		compareStr = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
					  self.vehicle2.name,
					  [[Savings currencyFormatter] stringFromNumber:savings],
					  years];
	} else {
		NSNumber *savings = [NSNumber numberWithFloat:[vehicle2TotalCost floatValue] - [vehicle1TotalCost floatValue]];
		compareStr = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
					  self.vehicle1.name,
					  [[Savings currencyFormatter] stringFromNumber:savings],
					  years];
	}
	return compareStr;
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

	self.cityRatio = [NSNumber numberWithFloat:kSavingsDefaultCityRatio];
	self.highwayRatio = [NSNumber numberWithFloat:kSavingsDefaultHighwayRatio];
	self.distance = [NSNumber numberWithInteger:kSavingsDefaultDistance];
	self.carOwnership = [NSNumber numberWithInteger:kSavingsDefaultCarOwnership];
	self.vehicle1 = [Vehicle vehicleWithName:kSavingsVehicle1DefaultName country:country_];
	self.vehicle2 = [Vehicle vehicleWithName:kSavingsVehicle2DefaultName country:country_];
}

- (BOOL)isSavingsEmpty
{
	NSInteger nameLength = [self.name length];
	CGFloat cityValue = [self.cityRatio floatValue];
	CGFloat highwayValue = [self.highwayRatio floatValue];
	NSInteger distanceValue = [self.distance integerValue];
	NSInteger ownershipValue = [self.carOwnership integerValue];
	BOOL vehicle1Value = [self.vehicle1 isVehicleEmpty];
	BOOL vehicle2Value = [self.vehicle2 isVehicleEmpty];
	
	if (nameLength == 0 && self.type == EfficiencyTypeNone && cityValue == 0.0 && highwayValue == 0.0 &&
		distanceValue == 0 && ownershipValue == 0 && vehicle1Value == YES && vehicle2Value == YES)
	{
		return YES;
	}
	return NO;
}

#pragma mark - Private Methods

- (void)setCountry:(id)country
{
	[country_ autorelease];
	country_ = [country retain];
}

- (NSNumber *)annualCostForVehicle:(Vehicle *)vehicle
{
	if (self.type == EfficiencyTypeAverage) {
		NSNumber *distance = nil;
		NSNumber *efficiency = nil;
		
		if ([vehicle.country isEqualToString:kCountriesAvailablePuertoRico]) {
			distance = [self.distance milesToKilometers];
			efficiency = [vehicle.avgEfficiency milesPerGallonToKilometersPerLiter];
		} else {
			distance = self.distance;
			efficiency = vehicle.avgEfficiency;
		}
		return [NSNumber fuelCostWithPrice:vehicle.fuelPrice distance:distance efficiency:efficiency];
	}
	
	NSNumber *distance = nil;
	NSNumber *cityEfficiency = nil;
	NSNumber *highwayEfficiency = nil;
	
	if ([self.country isEqualToString:kCountriesAvailablePuertoRico]) {
		distance = [self.distance milesToKilometers];
		cityEfficiency = [vehicle.cityEfficiency milesPerGallonToKilometersPerLiter];
		highwayEfficiency = [vehicle.highwayEfficiency milesPerGallonToKilometersPerLiter];
	} else {
		distance = self.distance;
		cityEfficiency = vehicle.cityEfficiency;
		highwayEfficiency = vehicle.highwayEfficiency;
	}
	
	NSNumber *cityFuelCost = [NSNumber fuelCostWithPrice:vehicle.fuelPrice distance:distance efficiency:cityEfficiency];
	NSNumber *highwayFuelCost = [NSNumber fuelCostWithPrice:vehicle.fuelPrice distance:distance efficiency:highwayEfficiency];
	
	CGFloat annual = ([cityFuelCost floatValue] * [self.cityRatio floatValue]) + ([highwayFuelCost floatValue] * [self.highwayRatio floatValue]);
	return [NSNumber numberWithFloat:annual];
}

- (NSNumber *)totalCostForVehicle:(Vehicle *)vehicle
{
	return [NSNumber numberWithFloat:[self.carOwnership floatValue] * [[self annualCostForVehicle:vehicle] floatValue]];
}

+ (NSNumberFormatter *)percentFormatter
{
	if (percentFormatter_ == nil) {
		percentFormatter_ = [[NSNumberFormatter alloc] init];
		[percentFormatter_ setNumberStyle:NSNumberFormatterPercentStyle];
		[percentFormatter_ setMaximumFractionDigits:0];
	}
	return percentFormatter_;
}

+ (NSNumberFormatter *)currencyFormatter
{
	if (currencyFormatter_ == nil) {
		currencyFormatter_ = [[NSNumberFormatter alloc] init];
		[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter_ setMaximumFractionDigits:0];
	}
	return currencyFormatter_;
}

- (NSString *)description
{	
	NSString *descriptionStr = [NSString stringWithFormat:@"Name: %@, Type: %@, City Ratio: %@, "
								@"Highway Ratio: %@, Distance: %@, Ownership: %@ Vehicle 1: (%@) Vehicle 2: (%@)",
								self.name,
								[self stringForCurrentType],
								[self.cityRatio stringValue],
								[self.highwayRatio stringValue],
								[self.distance stringValue],
								[self.carOwnership stringValue],
								[self.vehicle1 description],
								[self.vehicle2 description]];
	return descriptionStr;
}

@end
