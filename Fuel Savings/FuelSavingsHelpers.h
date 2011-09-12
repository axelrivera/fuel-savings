//
//  FuelSavingsHelpers.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/7/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { EfficiencyTypeAverage, EfficiencyTypeCombined, EfficiencyTypeNone } EfficiencyType;

NSString *efficiencyTypeStringValue(EfficiencyType type);