//
//  Trip.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Trip.h"

@implementation Trip

@synthesize name = name_;
@synthesize fuelPrice = fuelPrice_;
@synthesize distance = distance_;
@synthesize vehicle = vehicle_;

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
	return trip;
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
		self.name = [decoder decodeObjectForKey:@"tripName"];
		self.fuelPrice = [decoder decodeObjectForKey:@"tripFuelPrice"];
		self.distance = [decoder decodeObjectForKey:@"tripDistance"];
		self.vehicle = [decoder decodeObjectForKey:@"tripVehicle"];
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
}

- (id)copyWithZone:(NSZone *)zone
{
	Trip *newTrip = [[Trip allocWithZone:zone] init];
	newTrip.name = self.name;
	newTrip.fuelPrice = self.fuelPrice;
	newTrip.distance = self.distance;
	newTrip.vehicle = self.vehicle;
	return newTrip;
}

- (void)dealloc
{
	[name_ release];
	[fuelPrice_ release];
	[distance_ release];
	[vehicle_ release];
	[super dealloc];
}

#pragma mark - Custom Methods

- (NSNumber *)tripCost
{
	float trip = 0.0;
	trip = [self.fuelPrice floatValue] * ([self.distance floatValue] / [self.vehicle.avgEfficiency floatValue]);
	return [NSNumber numberWithFloat:trip];
}

- (void)setDefaultValues
{
	self.name = @"";
	self.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"3.65"];
	self.distance = [NSNumber numberWithInteger:100];
	self.vehicle = [Vehicle vehicleWithName:@"Your Car"];
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

@end
