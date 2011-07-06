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
@synthesize type;
@synthesize fuelPrice = fuelPrice_;
@synthesize distance = distance_;
@synthesize carOwnership = carOwnership_;
@synthesize vehicles = vehicles_;

#pragma mark - Class Methods

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"";
		self.type = SavingsCalculationTypeAverage;
		self.fuelPrice = [NSDecimalNumber decimalNumberWithString:@"3.65"];
		self.distance = [NSNumber numberWithInteger:15000];
		self.carOwnership = [NSNumber numberWithInteger:5];
		self.vehicles = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (void)dealloc
{
	[name_ release];
	[fuelPrice_ release];
	[distance_ release];
	[carOwnership_ release];
	[vehicles_ release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	SavingsCalculation *newSavings = [[[self class] allocWithZone:zone] init];
	newSavings.name = self.name;
	newSavings.type = self.type;
	newSavings.fuelPrice = self.fuelPrice;
	newSavings.distance = self.distance;
	newSavings.carOwnership = self.carOwnership;
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.vehicles];
	newSavings.vehicles = array;
	[array release];
	NSLog(@"New Savings: %@", newSavings);
	return newSavings;
}

#pragma mark - Custom Setters and Getters

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
