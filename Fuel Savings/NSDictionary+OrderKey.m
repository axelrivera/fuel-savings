//
//  NSDictionary+OrderKey.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+OrderKey.h"

@implementation NSDictionary (NSDictionary_OrderKey)

- (NSArray *)orderedKeys
{
	NSArray *sortedArray = [self keysSortedByValueUsingSelector:@selector(compareOrderKey:)];
	return sortedArray;
}

- (NSComparisonResult)compareOrderKey:(NSDictionary *)dictionary
{
	if ([[self objectForKey:kNSDictionaryOrderKey] integerValue] > [[dictionary objectForKey:kNSDictionaryOrderKey] integerValue]) {
		return (NSComparisonResult)NSOrderedDescending;
	}
	
	if ([[self objectForKey:kNSDictionaryOrderKey] integerValue] < [[dictionary objectForKey:kNSDictionaryOrderKey] integerValue]) {
		return (NSComparisonResult)NSOrderedAscending;
	}
	return (NSComparisonResult)NSOrderedSame;
}

@end
