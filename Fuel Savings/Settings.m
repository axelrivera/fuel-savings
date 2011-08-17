//
//  Settings.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "FileHelpers.h"

NSString * const kSettingsUnitUnitKey = @"units";
NSString * const kSettingsUnitAliasKey = @"alias";
NSString * const kSettingsUnitNameKey = @"name";
NSString * const kSettingsUnitOrderKey = @"order";

static Settings *sharedSettings;

static NSDictionary *distanceUnits;
static NSDictionary *volumeUnits;
static NSDictionary *efficiencyUnits;

@interface Settings (Private)

+ (NSArray *)sortedUnitsFromDictionary:(NSDictionary *)dictionary;

@end

@implementation Settings

- (id)init
{
    self = [super init];
    if (self) {
//		NSString *countryStr = [[NSUserDefaults standardUserDefaults] objectForKey:@""];
//		if (countryStr == nil) {
//			countryStr = kDefaultContry;
//		}
//		self.currentCountry = countryStr;
    }
    
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - Class Methods

+ (NSDictionary *)distanceUnits
{
	if (distanceUnits == nil) {
		NSString *filePath = pathInMainBundle(@"DistanceUnits.plist");
		distanceUnits = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
	}
	return distanceUnits;
}

+ (NSDictionary *)volumeUnits
{
	if (volumeUnits == nil) {
		NSString *filePath = pathInMainBundle(@"VolumeUnits.plist");
		volumeUnits = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
	}
	return volumeUnits;
}

+ (NSDictionary *)efficiencyUnits
{
	if (efficiencyUnits == nil) {
		NSString *filePath = pathInMainBundle(@"EfficiencyUnits.plist");
		efficiencyUnits = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
	}
	return efficiencyUnits;
}

#pragma mark - Custom Methods

+ (NSArray *)sortedDistanceUnits
{
	return [Settings sortedUnitsFromDictionary:[Settings distanceUnits]];
}

+ (NSArray *)sortedVolumeUnits
{
	return [Settings sortedUnitsFromDictionary:[Settings volumeUnits]];
}

+ (NSArray *)sortedEfficiencyUnits
{
	return [Settings sortedUnitsFromDictionary:[Settings efficiencyUnits]];
}

#pragma mark - Custom Setters

//- (void)setCurrentCountry:(NSString *)currentCountry
//{
//	[currentCountry_ autorelease];
//	currentCountry_ = [currentCountry retain];
//	[[NSUserDefaults standardUserDefaults] setObject:currentCountry forKey:kAvailableCountriesKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

#pragma mark - Private Methods

+ (NSArray *)sortedUnitsFromDictionary:(NSDictionary *)dictionary
{
	NSArray *sortedArray =
	[dictionary keysSortedByValueUsingComparator:
	 ^(id obj1, id obj2) {
		 if ([[obj1 objectForKey:kSettingsUnitOrderKey] integerValue] > [[obj2 objectForKey:kSettingsUnitOrderKey] integerValue]) {
			 return (NSComparisonResult)NSOrderedDescending;
		 }
		 
		 if ([[obj1 objectForKey:kSettingsUnitOrderKey] integerValue] < [[obj2 objectForKey:kSettingsUnitOrderKey] integerValue]) {
			 return (NSComparisonResult)NSOrderedAscending;
		 }
		 return (NSComparisonResult)NSOrderedSame;
	 }];
	return sortedArray;
}

#pragma mark - Singleton Methods

+ (Settings *)sharedSettings
{
    if (sharedSettings == nil) {
        sharedSettings = [[super allocWithZone:NULL] init];
    }
    return sharedSettings;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedSettings] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
