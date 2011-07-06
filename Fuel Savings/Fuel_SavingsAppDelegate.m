//
//  Fuel_SavingsAppDelegate.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fuel_SavingsAppDelegate.h"
#import "SavingsData.h"
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
	[SavingsData sharedSavingsData];
	
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
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
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
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[window_ release];
	[tabBarController_ release];
    [super dealloc];
}

@end
