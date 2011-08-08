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

@synthesize savingsCalculation = savingsCalculation_;
@synthesize savedCalculations = savedCalculations_;

- (id)init
{
	self = [super init];
	if (self) {
		self.savingsCalculation = nil;
		self.savedCalculations = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) { // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
		self.savingsCalculation = [decoder decodeObjectForKey:@"savingsDataSavingsCalculation"];
		self.savedCalculations = [decoder decodeObjectForKey:@"savingsDataSavedCalculations"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.savingsCalculation forKey:@"savingsDataSavingsCalculation"];
	[encoder encodeObject:self.savedCalculations forKey:@"savingsDataSavedCalculations"];
}

- (void)dealloc
{
	[savingsCalculation_ release];
	[savedCalculations_ release];
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
