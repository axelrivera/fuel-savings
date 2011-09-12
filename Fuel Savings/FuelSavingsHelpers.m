//
//  FuelSavingsHelpers.m
//  Fuel Savings
//
//  Created by Axel Rivera on 7/15/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

NSString *efficiencyTypeStringValue(EfficiencyType type)
{
	if (type == EfficiencyTypeAverage) {
		return @"Average MPG";
	} else if (type == EfficiencyTypeCombined) {
		return @"City / Highway MPG";
	}
	return @"EfficiencyTypeNone";
}