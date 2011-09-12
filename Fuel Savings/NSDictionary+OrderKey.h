//
//  NSDictionary+OrderKey.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNSDictionaryOrderKey @"order"

@interface NSDictionary (NSDictionary_OrderKey)

- (NSArray *)orderedKeys;
- (NSComparisonResult)compareOrderKey:(NSDictionary *)dictionary;

@end
