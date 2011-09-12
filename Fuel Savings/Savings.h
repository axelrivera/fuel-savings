//
//  Savings.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@interface Savings : NSObject <NSCoding, NSCopying> 

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) EfficiencyType type;
@property (nonatomic, retain) NSNumber *cityRatio;
@property (nonatomic, retain) NSNumber *highwayRatio;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSNumber *carOwnership;
@property (nonatomic, retain) Vehicle *vehicle1;
@property (nonatomic, retain) Vehicle *vehicle2;
@property (nonatomic, retain, readonly) NSString *country;

+ (Savings *)calculation;
+ (Savings *)emptySavings;

- (NSString *)stringForName;
- (NSString *)stringForCurrentType;
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
