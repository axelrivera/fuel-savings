//
//  Trip.m
//  Fuel Savings
//
//  Created by Axel Rivera on 7/15/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "Trip.h"
#import "NSNumber+Units.h"
#import "Settings.h"

@interface Trip (Private)

- (void)setCountry:(NSString *)country;

@end

@implementation Trip

@synthesize name = name_;
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
	trip.distance = [NSNumber numberWithInteger:0];
	trip.vehicle = [Vehicle emptyVehicle];
	[trip setCountry:nil];
	return trip;
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
		self.name = [decoder decodeObjectForKey:@"tripName"];
		self.distance = [decoder decodeObjectForKey:@"tripDistance"];
		self.vehicle = [decoder decodeObjectForKey:@"tripVehicle"];
		[self setCountry:[decoder decodeObjectForKey:@"tripCountry"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.name forKey:@"tripName"];
	[encoder encodeObject:self.distance forKey:@"tripDistance"];
	[encoder encodeObject:self.vehicle forKey:@"tripVehicle"];
	[encoder encodeObject:self.country forKey:@"tripCountry"];
}

- (id)copyWithZone:(NSZone *)zone
{
	Trip *myTrip = [[Trip allocWithZone:zone] init];
	myTrip.name = self.name;
	myTrip.distance = self.distance;
	myTrip.vehicle = self.vehicle;
	[myTrip setCountry:self.country];
	return myTrip;
}

- (void)dealloc
{
	[name_ release];
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
	return [NSNumber fuelCostWithPrice:self.vehicle.fuelPrice distance:distance efficiency:efficiency];
}

- (void)setDefaultValues
{
	self.name = kTripDefaultName;
	self.distance = [NSNumber numberWithInteger:kTripDefaultDistance];
	self.vehicle = [Vehicle vehicleWithName:kTripDefaultVehicleName country:country_];
}

- (NSString *)stringForName
{
	return self.name;
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

#pragma mark - Private Methods

- (void)setCountry:(NSString *)country
{
	[country_ autorelease];
	country_ = [country retain];
}

- (BOOL)isTripEmpty
{
	NSInteger nameLength = [self.name length];
	NSInteger distanceValue = [self.distance integerValue];
	BOOL vehicleValue = [self.vehicle isVehicleEmpty];
	
	if (nameLength == 0 && distanceValue == 0 && vehicleValue == YES) {
		return YES;
	}
	return NO;
}

- (NSString *)description
{
	NSString *descriptionStr = [NSString stringWithFormat:@"Name: %@, Distance: %@, Vehicle: (%@)",
								self.name,
								[self.distance stringValue],
								[self.vehicle description]];
	return descriptionStr;
}

@end
