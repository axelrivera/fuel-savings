//
//  Vehicle.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavingsCalculation;

@interface Vehicle : NSObject <NSCopying> {
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *avgEfficiency;
@property (nonatomic, copy) NSNumber *cityEfficiency;
@property (nonatomic, copy) NSNumber *highwayEfficiency;

+ (Vehicle *)vehicle;
+ (Vehicle *)vehicleWithName:(NSString *)name;

- (id)initWithName:(NSString *)name;

- (BOOL)hasDataReadyForType:(EfficiencyType)type;

@end
