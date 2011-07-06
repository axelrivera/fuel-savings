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

@synthesize newCalculation = newCalculation_;
@synthesize currentCalculation = currentCalculation_;

- (id)init
{
	self = [super init];
	if (self) {
		[self resetNewCalculation];
		[self resetCurrentCalculation];
	}
	return self;
}

- (void)dealloc
{
	[newCalculation_ release];
	[currentCalculation_ release];
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

- (void)resetNewCalculation
{
	self.newCalculation = [[[SavingsCalculation alloc] init] autorelease];
}

- (void)resetCurrentCalculation
{
	self.currentCalculation = [[[SavingsCalculation alloc] init] autorelease];
}


@end
