//
//  TripData.h
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface TripData : NSObject {
    
}

@property (nonatomic, assign) Trip *currentCalculation;
@property (nonatomic, retain) Trip *tripCalculation;
@property (nonatomic, retain) NSMutableArray *savedCalculations;

+ (TripData *)sharedTripData;

@end
