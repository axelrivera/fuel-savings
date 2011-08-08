//
//  SavingsData.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Savings.h"

@interface SavingsData : NSObject <NSCoding>

@property (nonatomic, retain) Savings *savingsCalculation;
@property (nonatomic, retain) NSMutableArray *savedCalculations; 

+ (SavingsData *)sharedSavingsData;

@end
