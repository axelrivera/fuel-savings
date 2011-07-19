//
//  Fuel_SavingsAppDelegate.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fuel_SavingsAppDelegate.h"
#import "FileHelpers.h"
#import "SavingsData.h"
#import "TripData.h"
#import "FuelSavingsViewController.h"
#import "TripViewController.h"
#import "MySavingsViewController.h"
#import "MPGDatabaseViewController.h"
#import "SettingsViewController.h"

@implementation Fuel_SavingsAppDelegate

@synthesize window = window_;
@synthesize tabBarController = tabBarController_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSString *savingsDataPath = [self savingsDataFilePath];
	SavingsData *savingsData = [NSKeyedUnarchiver unarchiveObjectWithFile:savingsDataPath];
	
	if (savingsData == nil)
		[SavingsData sharedSavingsData];
	
	NSString *tripDataPath = [self tripDataFielPath];
	TripData *tripData = [NSKeyedUnarchiver unarchiveObjectWithFile:tripDataPath];
	
	if (tripData == nil) {
		[TripData sharedTripData];
	}
	
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:5];
	
	FuelSavingsViewController *fuelSavingViewController = [[FuelSavingsViewController alloc] initWithTabBar];
	UINavigationController *fuelSavingNavigationController = [[UINavigationController alloc] initWithRootViewController:fuelSavingViewController];
	
	[viewControllers addObject:fuelSavingNavigationController];
	
	[fuelSavingViewController release];
	[fuelSavingNavigationController release];
	
	TripViewController *tripViewController = [[TripViewController alloc] initWithTabBar];
	UINavigationController *tripNavigationController = [[UINavigationController alloc] initWithRootViewController:tripViewController];
	
	[viewControllers addObject:tripNavigationController];
	
	[tripViewController release];
	[tripNavigationController release];
	
	MySavingsViewController *mySavingsViewController = [[MySavingsViewController alloc] initWithTabBar];
	UINavigationController *mySavingsNavigationController = [[UINavigationController alloc] initWithRootViewController:mySavingsViewController];
	
	[viewControllers addObject:mySavingsNavigationController];
	
	[mySavingsViewController release];
	[mySavingsNavigationController release];
	
	MPGDatabaseViewController *mpgDatabaseViewController = [[MPGDatabaseViewController alloc] initWithTabBar];
	UINavigationController *mpgDatabaseNavigationController = [[UINavigationController alloc] initWithRootViewController:mpgDatabaseViewController];
	
	[viewControllers addObject:mpgDatabaseNavigationController];
	
	[mpgDatabaseViewController release];
	[mpgDatabaseNavigationController release];
	
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithTabBar];
	UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	
	[viewControllers addObject:settingsNavigationController];
	
	[settingsViewController release];
	[settingsNavigationController release];
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
	self.tabBarController = tabBarController;
	
	[tabBarController release];
	
	self.tabBarController.viewControllers = viewControllers;
	
	[viewControllers release];
	
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self archiveSavingsData];
	[self archiveTripData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self archiveSavingsData];
	[self archiveTripData];
}

- (NSString *)savingsDataFilePath
{
	return pathInDocumentDirectory(@"savingsData.data");
}

- (void)archiveSavingsData
{
	NSString *savingsDataPath = [self savingsDataFilePath];
	[NSKeyedArchiver archiveRootObject:[SavingsData sharedSavingsData] toFile:savingsDataPath];
}

- (NSString *)tripDataFielPath
{
	return pathInDocumentDirectory(@"tripData.data");
}

- (void)archiveTripData
{
	NSString *tripDataPath = [self tripDataFielPath];
	[NSKeyedArchiver archiveRootObject:[TripData sharedTripData] toFile:tripDataPath];
}

- (void)dealloc
{
	[window_ release];
	[tabBarController_ release];
    [super dealloc];
}

@end
