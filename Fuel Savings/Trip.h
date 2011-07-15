//
//  Trip.h
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@interface Trip : NSObject <NSCoding, NSCopying> {
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDecimalNumber *fuelPrice;
@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) Vehicle *vehicle;

+ (id)calculation;

@end
