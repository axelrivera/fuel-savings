//
//  Vehicle.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Vehicle.h"

@implementation Vehicle

@synthesize name = name_;
@synthesize avgEfficiency = avgEfficiency_;
@synthesize cityEfficiency = cityEfficiency_;
@synthesize highwayEfficiency = highwayEfficiency_;

+ (Vehicle *)vehicle
{
	
	return [[[Vehicle alloc] init] autorelease];
}

+ (Vehicle *)vehicleWithName:(NSString *)name
{
	return [[[Vehicle alloc] initWithName:name] autorelease];
}

+ (Vehicle *)emptyVehicle
{
	Vehicle *vehicle = [Vehicle vehicle];
	vehicle.name = @"";
	vehicle.avgEfficiency = [NSNumber numberWithInteger:0];
	vehicle.cityEfficiency = [NSNumber numberWithInteger:0];
	vehicle.highwayEfficiency = [NSNumber numberWithInteger:0];
	return vehicle;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
		self.avgEfficiency = [NSNumber numberWithInteger:0];
		self.cityEfficiency = [NSNumber numberWithInteger:0];
		self.highwayEfficiency = [NSNumber numberWithInteger:0];
	}
	return self;
}

- (id)initWithName:(NSString *)name
{
	self = [self init];
	if (self) {
		self.name = name;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init]; // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
	if (self) {
		self.name = [decoder decodeObjectForKey:@"vehicleName"];
		self.avgEfficiency = [decoder decodeObjectForKey:@"vehicleAvgEfficiency"];
		self.cityEfficiency = [decoder decodeObjectForKey:@"vehicleCityEfficiency"];
		self.highwayEfficiency = [decoder decodeObjectForKey:@"vehicleHighwayEfficiency"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.name forKey:@"vehicleName"];
	[encoder encodeObject:self.avgEfficiency forKey:@"vehicleAvgEfficiency"];
	[encoder encodeObject:self.cityEfficiency forKey:@"vehicleCityEfficiency"];
	[encoder encodeObject:self.highwayEfficiency forKey:@"vehicleHighwayEfficiency"];
}

- (id)copyWithZone:(NSZone *)zone
{
	Vehicle *newVehicle = [[Vehicle allocWithZone:zone] init];
	newVehicle.name = self.name;
	newVehicle.avgEfficiency = self.avgEfficiency;
	newVehicle.cityEfficiency = self.cityEfficiency;
	newVehicle.highwayEfficiency = self.highwayEfficiency;
	return newVehicle;
}

- (void)dealloc
{
	[name_ release];
	[avgEfficiency_ release];
	[cityEfficiency_ release];
	[highwayEfficiency_ release];
	[super dealloc];
}

#pragma mark - Custom Methods

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
	NSInteger avgValue = [self.avgEfficiency integerValue];
	NSInteger cityValue = [self.cityEfficiency integerValue];
	NSInteger highwayValue = [self.highwayEfficiency integerValue];
	
	if (nameLength == 0 && avgValue == 0 && cityValue == 0 && highwayValue == 0) {
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

@end
