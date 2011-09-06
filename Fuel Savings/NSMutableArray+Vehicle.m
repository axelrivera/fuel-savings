//
//  NSMutableArray+Vehicle.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Vehicle.h"

@implementation NSMutableArray (NSMutableArray_Vehicle)

- (void)addVehicle:(Vehicle *)vehicle
{
	[self addObject:vehicle];
}

- (void)insertVehicle:(Vehicle *)vehicle atIndex:(NSInteger)index
{
	[self insertObject:vehicle atIndex:index];
}

@end
