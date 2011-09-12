//
//  Settings.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/16/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "Settings.h"
#import "FileHelpers.h"

// Local Constants

NSString * const kSettingsDistanceUnitKey = @"SettingsDistanceUnitKey";
NSString * const kSettingsVolumeUnitKey = @"SettingsVolumeUnitKey";
NSString * const kSettingsEfficiencyUnitKey = @"SettingsEfficiencyUnitKey";
NSString * const kSettingsCurrencySymbolKey = @"SettingsCurrencySymbolKey";
NSString * const kSettingsCountriesAvailableKey = @"SettingsCountriesAvailableKey";

NSString * const kSettingsDefaultDistanceUnit = kDistanceUnitsMileKey;
NSString * const kSettingsDefaultVolumeUnit = kVolumeUnitsGallonKey;
NSString * const kSettingsDefaultEfficiencyUnit = kEfficiencyUnitsMilesPerGallonKey;
NSString * const kSettingsDefaultCurrencySymbol = kCurrencySymbolsDollarKey;
NSString * const kSettingsDefaultCountry = kCountriesAvailableDefault;

// Local Variables

static Settings *sharedSettings;

static NSDictionary *distanceUnits;
static NSDictionary *volumeUnits;
static NSDictionary *efficiencyUnits;
static NSDictionary *currencySymbols;
static NSDictionary *countries;

@implementation Settings

@synthesize defaultDistanceUnit = defaultDistanceUnit_;
@synthesize defaultVolumeUnit = defaultVolumeUnit_;
@synthesize defaultEfficiencyUnit = defaultEfficiencyUnit_;
@synthesize defaultCurrencySymbol = defaultCurrencySymbol_;
@synthesize defaultCountry = defaultCountry_;

- (id)init
{
	self = [super init];
	if (self) {		
		NSString *distanceStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsDistanceUnitKey];
		if (distanceStr == nil) {
			distanceStr = kSettingsDefaultDistanceUnit;
		}
		self.defaultDistanceUnit = distanceStr;
		
		NSString *volumeStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsVolumeUnitKey];
		if (volumeStr == nil) {
			volumeStr = kSettingsDefaultVolumeUnit;
		}
		self.defaultVolumeUnit = volumeStr;
		
		NSString *efficiencyStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsEfficiencyUnitKey];
		if (efficiencyStr == nil) {
			efficiencyStr = kSettingsDefaultEfficiencyUnit;
		}
		self.defaultEfficiencyUnit = efficiencyStr;
		
		NSString *currencyStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsCurrencySymbolKey];
		if (currencyStr == nil) {
			currencyStr = kSettingsDefaultCurrencySymbol;
		}
		self.defaultCurrencySymbol = currencyStr;
		
		NSString *countryStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsCountriesAvailableKey];
		if (countryStr == nil) {
			countryStr = kSettingsDefaultCountry;
		}
		self.defaultCountry = countryStr;
	}
	
	return self;
}

- (void)dealloc
{
	[defaultDistanceUnit_ release];
	[defaultVolumeUnit_ release];
	[defaultEfficiencyUnit_ release];
	[defaultCurrencySymbol_ release];
	[defaultCountry_ release];
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

+ (NSDictionary *)currencySymbols
{
	if (currencySymbols == nil) {
		NSString *filePath = pathInMainBundle(@"CurrencySymbols.plist");
		currencySymbols = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
	}
	return currencySymbols;
}

+ (NSDictionary *)countries
{
	if (countries == nil) {
		NSString *filePath = pathInMainBundle(@"CountriesAvailable.plist");
		countries = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
	}
	return countries;
}

+ (NSArray *)orderedDistanceUnits
{
	return [[Settings distanceUnits] orderedKeys];
}

+ (NSArray *)orderedVolumeUnits
{
	return [[Settings volumeUnits] orderedKeys];
}

+ (NSArray *)orderedEfficiencyUnits
{
	return [[Settings efficiencyUnits] orderedKeys];
}

+ (NSArray *)orderedCurrencySymbols
{
	return [[Settings currencySymbols] orderedKeys];
}

+ (NSArray *)orderedCountries
{
	return [[Settings countries] orderedKeys];
}

#pragma mark - Custom Setters

- (void)setDefaultDistanceUnit:(NSString *)defaultDistanceUnit
{
	[defaultDistanceUnit_ autorelease];
	defaultDistanceUnit_ = [defaultDistanceUnit retain];
	[[NSUserDefaults standardUserDefaults] setObject:defaultDistanceUnit forKey:kSettingsDistanceUnitKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDefaultVolumeUnit:(NSString *)defaultVolumeUnit
{
	[defaultVolumeUnit_ autorelease];
	defaultVolumeUnit_ = [defaultVolumeUnit retain];
	[[NSUserDefaults standardUserDefaults] setObject:defaultVolumeUnit forKey:kSettingsVolumeUnitKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDefaultEfficiencyUnit:(NSString *)defaultEfficiencyUnit
{
	[defaultEfficiencyUnit_ autorelease];
	defaultEfficiencyUnit_ = [defaultEfficiencyUnit retain];
	[[NSUserDefaults standardUserDefaults] setObject:defaultEfficiencyUnit forKey:kSettingsEfficiencyUnitKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDefaultCurrencySymbol:(NSString *)defaultCurrencySymbol
{
	[defaultCurrencySymbol_ autorelease];
	defaultCurrencySymbol_ = [defaultCurrencySymbol retain];
	[[NSUserDefaults standardUserDefaults] setObject:defaultCurrencySymbol forKey:kSettingsCurrencySymbolKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDefaultCountry:(NSString *)defaultCountry
{
	[defaultCountry_ autorelease];
	defaultCountry_ = [defaultCountry retain];
	[[NSUserDefaults standardUserDefaults] setObject:defaultCountry forKey:kSettingsCountriesAvailableKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
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

- (oneway void)release
{
	//do nothing
}

- (id)autorelease
{
	return self;
}

@end
