//
//  NSNumber+FuelEfficiency.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NSNumber_Units)

+ (NSNumber *)fuelCostWithPrice:(NSNumber *)price distance:(NSNumber *)distance efficiency:(NSNumber *)efficiency;

- (NSNumber *)milesToKilometers;
- (NSNumber *)kilometersToMiles;

- (NSNumber *)milesPerGallonToKilometersPerLiter;
- (NSNumber *)milesPerImperialGallonToKilometersPerLiter;
- (NSNumber *)milesPerHundresKilometersToKilometersPerLiter;

- (NSNumber *)milesPerGallonToMilesPerImperialGallon;
- (NSNumber *)milesPerGallonToLitersPerHundredKilometers;

@end
