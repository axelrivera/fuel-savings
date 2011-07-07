//
//  SavingsCalculation.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

typedef enum { SavingsCalculationTypeAverage, SavingsCalculationTypeCombined } SavingsCalculationType;

@interface SavingsCalculation : NSObject <NSCopying> {

}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) SavingsCalculationType type;
@property (nonatomic, copy) NSDecimalNumber *fuelPrice;
@property (nonatomic, copy) NSNumber *cityRatio;
@property (nonatomic, copy) NSNumber *highwayRatio;
@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSNumber *carOwnership;
@property (nonatomic, copy) Vehicle *vehicle1;
@property (nonatomic, copy) Vehicle *vehicle2;

+ (NSString *)stringValueForType:(SavingsCalculationType)type;

- (NSString *)stringForCurrentType;

- (NSNumber *)annualCostForVehicle1;
- (NSNumber *)totalCostForVehicle1;

- (NSNumber *)annualCostForVehicle2;
- (NSNumber *)totalCostForVehicle2;

@end
