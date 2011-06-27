//
//  SavingsCalculation.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsCalculation.h"

#define MAX_VEHICLES 5

@implementation SavingsCalculation

@synthesize name = name_;
@synthesize savingsCalculationType, fuelPrice, carOwnership;

- (id)init
{
	self = [super init];
	if (self) {
		vehicles_ = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}

- (void)dealloc
{
	[name_ release];
	[vehicles_ release];
	[super dealloc];
}

#pragma mark - Custom Setters and Getters

- (NSArray *)vehicles
{
	return vehicles_;
}

#pragma mark - Custom Methods

- (BOOL)addVehicle:(id)vehicle
{
	NSAssert([vehicle isKindOfClass:[Vehicle class]], @"The object is not a vehicle");
	if ([vehicles_ count] > MAX_VEHICLES) {
		return NO;
	}
	
	[vehicles_ addObject:vehicle];
	return YES;
}

- (void)removeVehicleAtIndex:(NSInteger)index
{
	[vehicles_ removeObjectAtIndex:index];
}

- (void)removeAllVehicles
{
	[vehicles_ removeAllObjects];
}

@end
