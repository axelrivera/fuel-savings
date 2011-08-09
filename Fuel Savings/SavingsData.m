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
		self.currentSavings = [Savings emptySavings];
		self.currentTrip = [Trip emptyTrip];
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

+ (SavingsData *)sharedSavingsData
{
    if (sharedSavingsData == nil) {
        sharedSavingsData = [[super allocWithZone:NULL] init];
    }
    return sharedSavingsData;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedSavingsData] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
@end
