//
//  Settings.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+OrderKey.h"

#define kSettingsUnitUnitKey @"unit"
#define kSettingsUnitAliasKey @"alias"
#define kSettingsUnitNameKey @"name"
#define kSettingsUnitOrderKey kNSDictionaryOrderKey

@interface Settings : NSObject

@property (nonatomic, retain) NSString *defaultDistanceUnit;
@property (nonatomic, retain) NSString *defaultVolumeUnit;
@property (nonatomic, retain) NSString *defaultEfficiencyUnit;
@property (nonatomic, retain) NSString *defaultCurrencySymbol;
@property (nonatomic, retain) NSString *defaultCountry;


+ (Settings *)sharedSettings;

+ (NSDictionary *)distanceUnits;
+ (NSDictionary *)volumeUnits;
+ (NSDictionary *)efficiencyUnits;
+ (NSDictionary *)currencySymbols;
+ (NSDictionary *)countries;

+ (NSArray *)orderedDistanceUnits;
+ (NSArray *)orderedVolumeUnits;
+ (NSArray *)orderedEfficiencyUnits;
+ (NSArray *)orderedCurrencySymbols;
+ (NSArray *)orderedCountries;

@end
