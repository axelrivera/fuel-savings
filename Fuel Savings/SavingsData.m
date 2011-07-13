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

@synthesize currentCalculation = currentCalculation_;
@synthesize savedCalculations = savedCalculations_;

- (id)init
{
	self = [super init];
	if (self) {
		self.currentCalculation = nil;
		self.savedCalculations = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) { // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
		self.currentCalculation = [decoder decodeObjectForKey:@"savingsDataCurrentCalculation"];
		self.savedCalculations = [decoder decodeObjectForKey:@"savingsDataSavedCalculations"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:self.currentCalculation forKey:@"savingsDataCurrentCalculation"];
	[encoder encodeObject:self.savedCalculations forKey:@"savingsDataSavedCalculations"];
}

- (void)dealloc
{
	[currentCalculation_ release];
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

- (void)release {
    // No op
}

#pragma mark - Custom Methods

- (void)setupCurrentCalculation
{
	self.currentCalculation = [[[SavingsCalculation alloc] init] autorelease];
}


@end
