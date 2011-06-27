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
@synthesize avgMPG, cityMPG, highwayMPG;

- (id)init
{
	self = [super init];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[name_ release];
	[super dealloc];
}

@end
