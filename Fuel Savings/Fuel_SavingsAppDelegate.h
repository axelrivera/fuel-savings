//
//  Fuel_SavingsAppDelegate.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ApplicationDelegate ((Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate])
#define SharedAdBannerView ((Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate]).adBanner

@class RLCoreDataObject;

@interface Fuel_SavingsAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) RLCoreDataObject *coreDataObject;

- (NSString *)savingsDataFilePath;
- (void)archiveSavingsData;

@end
