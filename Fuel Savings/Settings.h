//
//  Settings.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kSettingsUnitUnitKey;
extern NSString * const kSettingsUnitAliasKey;
extern NSString * const kSettingsUnitNameKey;
extern NSString * const kSettingsUnitOrderKey;

@interface Settings : NSObject

+ (Settings *)sharedSettings;

+ (NSDictionary *)distanceUnits;
+ (NSDictionary *)volumeUnits;
+ (NSDictionary *)efficiencyUnits;

+ (NSArray *)sortedDistanceUnits;
+ (NSArray *)sortedVolumeUnits;
+ (NSArray *)sortedEfficiencyUnits;

@end
