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

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) Vehicle *vehicle;
@property (nonatomic, retain, readonly) NSString *country;

+ (Trip *)calculation;
+ (Trip *)emptyTrip;

- (NSNumber *)tripCost;
- (void)setDefaultValues;

- (NSString *)stringForName;
- (NSString *)stringForDistance;

- (NSString *)stringForTripCost;

- (BOOL)isTripEmpty;

@end
