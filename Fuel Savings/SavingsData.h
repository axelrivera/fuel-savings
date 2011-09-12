//
//  SavingsData.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/28/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Savings.h"
#import "Trip.h"

@interface SavingsData : NSObject <NSCoding>

@property (nonatomic, retain) Savings *currentSavings;
@property (nonatomic, retain) Trip *currentTrip;
@property (nonatomic, retain) NSMutableArray *savingsArray;
@property (nonatomic, retain) NSMutableArray *tripArray;

+ (SavingsData *)sharedSavingsData;

@end
