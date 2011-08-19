//
//  Trip.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Trip.h"
#import "NSNumber+Units.h"

@implementation Trip

@synthesize name = name_;
@synthesize fuelPrice = fuelPrice_;
@synthesize distance = distance_;
@synthesize vehicle = vehicle_;
@synthesize country = country_;

+ (Trip *)calculation
{
	return [[[Trip alloc] init] autorelease];
}

+ (Trip *)emptyTrip
{
	Trip *trip = [Trip calculation];
	trip.name = @"";
	trip.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
	trip.distance = [NSNumber numberWithInteger:0];
	trip.vehicle = [Vehicle emptyVehicle];
	trip.country = nil;
	return trip;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.country = kCountriesAvailableUnitedStates;
		[self setDefaultValues];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init]; // this needs to be [super initWithCoder:decoder] if the superclass implements NSCoding
	if (self) {
		self.name = [decoder decodeObjectForKey:@"tripName"];
		self.fuelPrice = [decoder decodeObjectForKey:@"tripFuelPrice"];
		self.distance = [decoder decodeObjectForKey:@"tripDistance"];
		self.vehicle = [decoder decodeObjectForKey:@"tripVehicle"];
		self.country = [decoder decodeObjectForKey:@"tripCountry"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.name forKey:@"tripName"];
	[encoder encodeObject:self.fuelPrice forKey:@"tripFuelPrice"];
	[encoder encodeObject:self.distance forKey:@"tripDistance"];
	[encoder encodeObject:self.vehicle forKey:@"tripVehicle"];
	[encoder encodeObject:self.country forKey:@"tripCountry"];
}

- (id)copyWithZone:(NSZone *)zone
{
	Trip *newTrip = [[Trip allocWithZone:zone] init];
	newTrip.name = self.name;
	newTrip.fuelPrice = self.fuelPrice;
	newTrip.distance = self.distance;
	newTrip.vehicle = self.vehicle;
	newTrip.country = self.country;
	return newTrip;
}

- (void)dealloc
{
	[name_ release];
	[fuelPrice_ release];
	[distance_ release];
	[vehicle_ release];
	[country_ release];
	[super dealloc];
}

#pragma mark - Custom Methods

- (NSNumber *)tripCost
{	
	NSNumber *distance = nil;
	NSNumber *efficiency = nil;
	
	if ([self.country isEqualToString:kCountriesAvailablePuertoRico]) {
		distance = [self.distance milesToKilometers];
		efficiency = [self.vehicle.avgEfficiency milesPerGallonToKilometersPerLiter];
	} else {
		distance = self.distance;
		efficiency = self.vehicle.avgEfficiency;
	}
	return [NSNumber fuelCostWithPrice:self.fuelPrice distance:distance efficiency:efficiency];
}

- (void)setDefaultValues
{
	self.name = @"My Trip";
	
	NSString *priceStr = @"3.65";
	if ([self.country isEqualToString:kCountriesAvailablePuertoRico]) {
		priceStr = @"0.89";
	}
	
	self.fuelPrice = [NSDecimalNumber decimalNumberWithString:priceStr];
	self.distance = [NSNumber numberWithInteger:100];
	self.vehicle = [Vehicle vehicleWithName:@"My Car"];
}

- (NSString *)stringForName
{
	return self.name;
}

- (NSString *)stringForFuelPrice
{
	NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSString *priceStr = [priceFormatter stringFromNumber:self.fuelPrice];
	[priceFormatter release];
	
	NSString *unitStr = kVolumeUnitsGallonKey;
	if ([self.country isEqualToString:kCountriesAvailablePuertoRico]) {
		unitStr = kVolumeUnitsLiterKey;
	}
	
	return [NSString stringWithFormat:@"%@ /%@", priceStr, unitStr];
}

- (NSString *)stringForDistance
{
	NSNumberFormatter *distanceFormatter = [[NSNumberFormatter alloc] init];
	[distanceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[distanceFormatter setMaximumFractionDigits:0];
	
	NSString *distanceStr = [distanceFormatter stringFromNumber:self.distance];
	[distanceFormatter release];
	
	return [NSString stringWithFormat:@"%@ miles", distanceStr];
}

- (NSString *)stringForTripCost
{
	NSNumberFormatter *currencyFormatter_ = [[NSNumberFormatter alloc] init];
	[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
	[currencyFormatter_ setMaximumFractionDigits:0];
	
	NSString *costStr = [currencyFormatter_ stringFromNumber:[self tripCost]];
	[currencyFormatter_ release];
	
	return costStr;
}

- (BOOL)isTripEmpty
{
	NSInteger nameLength = [self.name length];
	CGFloat fuelValue = [self.fuelPrice floatValue];
	NSInteger distanceValue = [self.distance integerValue];
	BOOL vehicleValue = [self.vehicle isVehicleEmpty];
	
	if (nameLength == 0 && fuelValue == 0.0 && distanceValue == 0 && vehicleValue == YES) {
		return YES;
	}
	return NO;
}

- (NSString *)description
{
	NSString *descriptionStr = [NSString stringWithFormat:@"Name: %@, Price: %@, Distance: %@, Vehicle: (%@)",
								self.name,
								[self.fuelPrice stringValue],
								[self.distance stringValue],
								[self.vehicle description]];
	return descriptionStr;
}

@end
