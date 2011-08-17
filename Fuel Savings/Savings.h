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

- (NSString *)stringForName;
- (NSString *)stringForCurrentType;
- (NSString *)stringForFuelPrice;
- (NSString *)stringForCityRatio;
- (NSString *)stringForHighwayRatio;
- (NSString *)stringForDistance;
- (NSString *)stringForCarOwnership;

- (NSNumber *)annualCostForVehicle1;
- (NSNumber *)totalCostForVehicle1;

- (NSNumber *)annualCostForVehicle2;
- (NSNumber *)totalCostForVehicle2;

- (NSString *)stringForAnnualCostForVehicle1;
- (NSString *)stringForTotalCostForVehicle1;

- (NSString *)stringForAnnualCostForVehicle2;
- (NSString *)stringForTotalCostForVehicle2;

- (NSString *)annualCostCompareString;
- (NSString *)totalCostCompareString;

- (void)setRatioForCity:(NSNumber *)city highway:(NSNumber *)highway;
- (void)setDefaultValues;

- (BOOL)isSavingsEmpty;

@end
