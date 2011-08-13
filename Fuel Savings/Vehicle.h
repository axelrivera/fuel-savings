//
//  Vehicle.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuelSavingsHelpers.h"

@interface Vehicle : NSObject <NSCoding, NSCopying> {
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *avgEfficiency;
@property (nonatomic, copy) NSNumber *cityEfficiency;
@property (nonatomic, copy) NSNumber *highwayEfficiency;

+ (Vehicle *)vehicle;
+ (Vehicle *)vehicleWithName:(NSString *)name;
+ (Vehicle *)emptyVehicle;

- (id)initWithName:(NSString *)name;

- (NSString *)stringForName;
- (NSString *)stringForAvgEfficiency;
- (NSString *)stringForCityEfficiency;
- (NSString *)stringForHighwayEfficiency;

- (BOOL)hasDataReady;
- (BOOL)isVehicleEmpty;

@end
