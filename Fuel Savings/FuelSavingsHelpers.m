//
//  FuelSavingsHelpers.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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