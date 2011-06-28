//
//  SavingsData.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SavingsCalculation.h"

@interface SavingsData : NSObject {

}

@property (nonatomic, retain) SavingsCalculation *currentCalculation;

+ (SavingsData *)sharedSavingsData;

@end
