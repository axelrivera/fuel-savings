//
//  SavingsData.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsData.h"

static SavingsData *sharedSavingsData;

@implementation SavingsData

@synthesize currentSavings = currentSavings_;
@synthesize currentTrip = currentTrip_;
@synthesize savingsArray = savingsArray_;
@synthesize tripArray = tripArray_;

- (id)init
{
	self = [super init];
	if (self) {
		self.currentSavings = nil;
		self.currentTrip = nil;
		self.savingsArray = [NSMutableArray arrayWithCapacity:0];
		self.tripArray = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init]; // this needs to be [super initWithCoder:decoder] if the superclass implements NSCoding
	if (self) {
		self.currentSavings = [decoder decodeObjectForKey:@"savingsDataCurrentSavings"];
		self.currentTrip = [decoder decodeObjectForKey:@"savingsDataCurrentTrip"];
		self.savingsArray = [decoder decodeObjectForKey:@"savingsDataSavingsArray"];
		self.tripArray = [decoder decodeObjectForKey:@"savingsDataTripArray"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.currentSavings forKey:@"savingsDataCurrentSavings"];
	[encoder encodeObject:self.currentTrip forKey:@"savingsDataCurrentTrip"];
	[encoder encodeObject:self.savingsArray forKey:@"savingsDataSavingsArray"];
	[encoder encodeObject:self.tripArray forKey:@"savingsDataTripArray"];
}

- (void)dealloc
{
	[currentSavings_ release];
	[currentTrip_ release];
	[savingsArray_ release];
	[tripArray_ release];
	[super dealloc];
}

#pragma mark -
#pragma mark Singleton Methods

+ (SavingsData *)sharedSavingsData {
    if (!sharedSavingsData) {
        sharedSavingsData = [[[self class] alloc] init];
	}
    return sharedSavingsData;
}

+ (id)allocWithZone:(NSZone *)zone {
    if (!sharedSavingsData) {
        sharedSavingsData = [super allocWithZone:zone];
        return sharedSavingsData;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
