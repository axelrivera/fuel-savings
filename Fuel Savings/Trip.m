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

+ (id)calculation
{
	return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
		self.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"3.65"];
		self.distance = [NSNumber numberWithInteger:100];
		self.vehicle = [Vehicle vehicleWithName:@"Car"];
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
	Trip *newTrip = [[[self class] allocWithZone:zone] init];
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

@end
