//
//  FuelSavingsHelpers.h
//  Fuel Savings
//
//  Created by arn on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { EfficiencyTypeAverage, EfficiencyTypeCombined, EfficiencyTypeNone } EfficiencyType;

NSString *efficiencyTypeStringValue(EfficiencyType type);