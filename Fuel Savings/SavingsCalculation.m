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
@synthesize fuelPrice = fuelPrice_;
@synthesize type, distance, carOwnership;

#pragma mark - Class Methods

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
		self.type = SavingsCalculationTypeAverage;
		self.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"3.65"];
		self.distance = 15000;
		self.carOwnership = 5;
		vehicles_ = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}

- (void)dealloc
{
	[name_ release];
	[vehicles_ release];
	[fuelPrice_ release];
	[super dealloc];
}

#pragma mark - Custom Setters and Getters

- (NSArray *)vehicles
{
	return vehicles_;
}

#pragma mark - Custom Methods

- (NSString *)stringForCurrentType
{
	return [[self class] stringValueForType:self.type];
}

+ (NSString *)stringValueForType:(SavingsCalculationType)type
{
	if (type == SavingsCalculationTypeAverage) {
		return @"Average MPG";
	}
	return @"City / Highway MPG";
}

@end
