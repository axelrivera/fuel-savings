//
//  TripData.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TripData.h"

static TripData *sharedTripData;

@implementation TripData

@synthesize currentCalculation = currentCalculation_;
@synthesize tripCalculation = tripCalculation_;
@synthesize savedCalculations = savedCalculations_;

- (id)init
{
	self = [super init];
	if (self) {
		self.currentCalculation = nil;
		self.tripCalculation = nil;
		self.savedCalculations = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) { // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
		self.tripCalculation = [decoder decodeObjectForKey:@"tripDataTripCalculation"];
		self.savedCalculations = [decoder decodeObjectForKey:@"tripDataSavedCalculations"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.tripCalculation forKey:@"tripDataTripCalculation"];
	[encoder encodeObject:self.savedCalculations forKey:@"tripDataSavedCalculations"];
}

- (void)dealloc
{
	[tripCalculation_ release];
	[savedCalculations_ release];
	[super dealloc];
}

#pragma mark -
#pragma mark Singleton Methods

+ (TripData *)sharedTripData {
    if (!sharedTripData) {
        sharedTripData = [[[self class] alloc] init];
	}
    return sharedTripData;
}

+ (id)allocWithZone:(NSZone *)zone {
    if (!sharedTripData) {
        sharedTripData = [super allocWithZone:zone];
        return sharedTripData;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)release {
    // No op
}

@end
