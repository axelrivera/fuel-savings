//
//  NSMutableArray+Vehicle.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/28/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@interface NSMutableArray (NSMutableArray_Vehicle)

- (void)addVehicle:(Vehicle *)vehicle;
- (void)insertVehicle:(Vehicle *)vehicle atIndex:(NSInteger)index;

@end
