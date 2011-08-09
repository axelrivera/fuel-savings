//
//  Savings.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@interface Savings : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) EfficiencyType type;
@property (nonatomic, copy) NSDecimalNumber *fuelPrice;
@property (nonatomic, copy) NSNumber *cityRatio;
@property (nonatomic, copy) NSNumber *highwayRatio;
@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSNumber *carOwnership;
@property (nonatomic, copy) Vehicle *vehicle1;
@property (nonatomic, copy) Vehicle *vehicle2;

+ (Savings *)calculation;
+ (Savings *)emptySavings;

- (NSString *)stringForCurrentType;

- (NSNumber *)annualCostForVehicle1;
- (NSNumber *)totalCostForVehicle1;

- (NSNumber *)annualCostForVehicle2;
- (NSNumber *)totalCostForVehicle2;

- (void)setRatioForCity:(NSNumber *)city highway:(NSNumber *)highway;
- (void)setDefaultValues;

- (BOOL)isSavingsEmpty;

@end
