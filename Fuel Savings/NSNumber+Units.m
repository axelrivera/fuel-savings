//
//  NSNumber+FuelEfficiency.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "NSNumber+Units.h"

@implementation NSNumber (NSNumber_Units)

+ (NSNumber *)fuelCostWithPrice:(NSNumber *)price distance:(NSNumber *)distance efficiency:(NSNumber *)efficiency
{
	return [NSNumber numberWithFloat:[price floatValue] * ([distance floatValue] / [efficiency floatValue])];
}

- (NSNumber *)milesToKilometers
{
	return [NSNumber numberWithFloat:[self floatValue] * 1.609344];
}

- (NSNumber *)kilometersToMiles
{
	return [NSNumber numberWithFloat:[self floatValue] * 0.621371192];
}

- (NSNumber *)milesPerGallonToKilometersPerLiter
{
	return [NSNumber numberWithFloat:[self floatValue] * 0.425143707];
}

- (NSNumber *)milesPerImperialGallonToKilometersPerLiter
{
	return [NSNumber numberWithFloat:[self floatValue] * 0.354006044];
}

- (NSNumber *)milesPerHundresKilometersToKilometersPerLiter
{
	return [NSNumber numberWithFloat:[self floatValue] * 0.01];
}

- (NSNumber *)milesPerGallonToMilesPerImperialGallon
{
	return [NSNumber numberWithFloat:[self floatValue] * 1.20095042];
}

- (NSNumber *)milesPerGallonToLitersPerHundredKilometers
{
	return [NSNumber numberWithFloat:235.214583 / [self floatValue]];
}

@end
