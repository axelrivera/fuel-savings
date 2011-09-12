//
//  Trip.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/15/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@interface Trip : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) Vehicle *vehicle;
@property (nonatomic, copy, readonly) NSString *country;

+ (Trip *)calculation;
+ (Trip *)emptyTrip;

- (NSNumber *)tripCost;
- (void)setDefaultValues;

- (NSString *)stringForName;
- (NSString *)stringForDistance;

- (NSString *)stringForTripCost;

- (BOOL)isTripEmpty;

@end
