//
//  Vehicle.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Vehicle.h"
#import "SavingsCalculation.h"

@implementation Vehicle

@synthesize name = name_;
@synthesize avgEfficiency = avgEfficiency_;
@synthesize cityEfficiency = cityEfficiency_;
@synthesize highwayEfficiency = highwayEfficiency_;

+ (Vehicle *)vehicle
{
	
	return [[[[self class] alloc] init] autorelease];
}

+ (Vehicle *)vehicleWithName:(NSString *)name
{
	return [[[[self class] alloc] initWithName:name] autorelease];
}

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
#warning Remember to Change the default Value
		self.avgEfficiency = [NSNumber numberWithInteger:25];
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

- (void)dealloc
{
	[name_ release];
	[avgEfficiency_ release];
	[cityEfficiency_ release];
	[highwayEfficiency_ release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	Vehicle *newVehicle = [[[self class] allocWithZone:zone] init];
	newVehicle.name = self.name;
	newVehicle.avgEfficiency = self.avgEfficiency;
	newVehicle.cityEfficiency = self.cityEfficiency;
	newVehicle.highwayEfficiency = self.highwayEfficiency;
	return newVehicle;
}

#pragma mark - Custom Methods

- (BOOL)hasDataReadyForType:(EfficiencyType)type
{
	if (type == EfficiencyTypeAverage && [self.avgEfficiency integerValue] > 0) {
		return YES;
	}
	
	if (type == EfficiencyTypeCombined && ([self.cityEfficiency integerValue] > 0 && [self.highwayEfficiency integerValue] > 0)) {
		return YES;
	}
		
	return NO;
}

@end
