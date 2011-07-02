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

- (void)dealloc
{
	[name_ release];
	[avgEfficiency_ release];
	[cityEfficiency_ release];
	[highwayEfficiency_ release];
	[super dealloc];
}

@end
