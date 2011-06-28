//
//  SavingsCalculation.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

typedef enum { SavingsCalculationTypeAverage, SavingsCalculationTypeSeparate } SavingsCalculationType;

@interface SavingsCalculation : NSObject {
	NSMutableArray *vehicles_;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) SavingsCalculationType savingsCalculationType;
@property (nonatomic) CGFloat fuelPrice;
@property (nonatomic) NSInteger distance;
@property (nonatomic) NSInteger carOwnership;
@property (nonatomic, readonly) NSArray *vehicles;

- (BOOL)addVehicle:(id)vehicle;
- (void)removeVehicleAtIndex:(NSInteger)index;
- (void)removeAllVehicles;

@end
