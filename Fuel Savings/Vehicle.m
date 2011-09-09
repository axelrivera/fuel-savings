//
//  Vehicle.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Vehicle.h"

@interface Vehicle (Private)

- (void)setCountry:(NSString *)country;

@end

@implementation Vehicle

@synthesize name = name_;
@synthesize fuelPrice = fuelPrice_;
@synthesize avgEfficiency = avgEfficiency_;
@synthesize cityEfficiency = cityEfficiency_;
@synthesize highwayEfficiency = highwayEfficiency_;
@synthesize country = country_;

+ (Vehicle *)vehicle
{
	return [[[Vehicle alloc] init] autorelease];
}

+ (Vehicle *)vehicleWithName:(NSString *)name
{
	return [[[Vehicle alloc] initWithName:name] autorelease];
}

+ (Vehicle *)vehicleWithName:(NSString *)name country:(NSString *)country
{
	return [[[Vehicle alloc] initWithName:name country:country] autorelease];
}

+ (Vehicle *)emptyVehicle
{
	Vehicle *vehicle = [Vehicle vehicle];
	vehicle.name = @"";
	vehicle.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
	vehicle.avgEfficiency = [NSNumber numberWithInteger:0];
	vehicle.cityEfficiency = [NSNumber numberWithInteger:0];
	vehicle.highwayEfficiency = [NSNumber numberWithInteger:0];
	return vehicle;
}

- (id)init
{
	return [self initWithName:@"" country:kCountriesAvailableDefault];
}

- (id)initWithName:(NSString *)name
{
	return [self initWithName:name country:kCountriesAvailableDefault];
}

- (id)initWithName:(NSString *)name country:(NSString *)country
{
	self = [super init];
	if (self) {
		[self setCountry:country];
		self.name = name;
		self.fuelPrice = [self defaultPrice];  // Must be called after setCountry:
		self.avgEfficiency = [NSNumber numberWithInteger:0];
		self.cityEfficiency = [NSNumber numberWithInteger:0];
		self.highwayEfficiency = [NSNumber numberWithInteger:0];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init]; // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
	if (self) {
		self.name = [decoder decodeObjectForKey:@"vehicleName"];
		self.fuelPrice = [decoder decodeObjectForKey:@"vehicleFuelPrice"];
		self.avgEfficiency = [decoder decodeObjectForKey:@"vehicleAvgEfficiency"];
		self.cityEfficiency = [decoder decodeObjectForKey:@"vehicleCityEfficiency"];
		self.highwayEfficiency = [decoder decodeObjectForKey:@"vehicleHighwayEfficiency"];
		[self setCountry:[decoder decodeObjectForKey:@"vehicleCountry"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.name forKey:@"vehicleName"];
	[encoder encodeObject:self.fuelPrice forKey:@"vehicleFuelPrice"];
	[encoder encodeObject:self.avgEfficiency forKey:@"vehicleAvgEfficiency"];
	[encoder encodeObject:self.cityEfficiency forKey:@"vehicleCityEfficiency"];
	[encoder encodeObject:self.highwayEfficiency forKey:@"vehicleHighwayEfficiency"];
	[encoder encodeObject:self.country forKey:@"vehicleCountry"];
}

- (id)copyWithZone:(NSZone *)zone
{
	Vehicle *newVehicle = [[Vehicle allocWithZone:zone] init];
	newVehicle.name = self.name;
	newVehicle.fuelPrice = self.fuelPrice;
	newVehicle.avgEfficiency = self.avgEfficiency;
	newVehicle.cityEfficiency = self.cityEfficiency;
	newVehicle.highwayEfficiency = self.highwayEfficiency;
	[newVehicle setCountry:self.country];
	return newVehicle;
}

- (void)dealloc
{
	[name_ release];
	[fuelPrice_ release];
	[avgEfficiency_ release];
	[cityEfficiency_ release];
	[highwayEfficiency_ release];
	[country_ release];
	[super dealloc];
}

#pragma mark - Custom Methods

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

- (NSString *)stringForAvgEfficiency
{
	return [NSString stringWithFormat:@"%@ MPG", [self.avgEfficiency stringValue]];
}

- (NSString *)stringForCityEfficiency
{
	return [NSString stringWithFormat:@"%@ MPG", [self.cityEfficiency stringValue]];
}

- (NSString *)stringForHighwayEfficiency
{
	return [NSString stringWithFormat:@"%@ MPG", [self.highwayEfficiency stringValue]];
}

- (NSDecimalNumber *)defaultPrice
{
	NSString *priceStr = @"3.65";
	if ([country_ isEqualToString:kCountriesAvailablePuertoRico]) {
		priceStr = @"0.89";
	}
	return [NSDecimalNumber decimalNumberWithString:priceStr];
}

- (BOOL)hasDataReady
{
	if ([self.avgEfficiency integerValue] > 0 &&
		[self.cityEfficiency integerValue] > 0 &&
		[self.highwayEfficiency integerValue] > 0) {
		return YES;
	}
	return NO;
}

- (BOOL)isVehicleEmpty
{
	NSInteger nameLength = [self.name length];
	CGFloat fuelValue = [fuelPrice_ floatValue];
	NSInteger avgValue = [self.avgEfficiency integerValue];
	NSInteger cityValue = [self.cityEfficiency integerValue];
	NSInteger highwayValue = [self.highwayEfficiency integerValue];
	
	if (nameLength == 0 &&  fuelValue == 0.0 && avgValue == 0 && cityValue == 0 && highwayValue == 0) {
		return YES;
	}
	return NO;
}

- (NSString *)description
{
	NSString *descriptionStr = [NSString stringWithFormat:@"Name: %@, City: %@, Highway: %@, Combined: %@",
								self.name,
								[self.cityEfficiency stringValue],
								[self.highwayEfficiency stringValue],
								[self.avgEfficiency stringValue]];
	return descriptionStr;
}

#pragma mark - Private Methods

- (void)setCountry:(NSString *)country
{
	[country_ autorelease];
	country_ = [country retain];
}

@end
