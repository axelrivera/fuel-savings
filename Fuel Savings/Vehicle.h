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

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDecimalNumber *fuelPrice;
@property (nonatomic, retain) NSNumber *avgEfficiency;
@property (nonatomic, retain) NSNumber *cityEfficiency;
@property (nonatomic, retain) NSNumber *highwayEfficiency;
@property (nonatomic, retain, readonly) NSString *country;

+ (Vehicle *)vehicle;
+ (Vehicle *)vehicleWithName:(NSString *)name;
+ (Vehicle *)vehicleWithName:(NSString *)name country:(NSString *)country;
+ (Vehicle *)emptyVehicle;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name country:(NSString *)country;

- (NSString *)stringForName;
- (NSString *)stringForFuelPrice;
- (NSString *)stringForAvgEfficiency;
- (NSString *)stringForCityEfficiency;
- (NSString *)stringForHighwayEfficiency;

- (NSDecimalNumber *)defaultPrice;

- (BOOL)hasDataReady;
- (BOOL)isVehicleEmpty;

@end
