//
//  Fuel_SavingsAppDelegate.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#define SharedAdBannerView ((Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate]).adBanner

@class RLCoreDataObject;

@interface Fuel_SavingsAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) RLCoreDataObject *coreDataObject;
@property (nonatomic, retain) ADBannerView *adBanner;

- (NSString *)savingsDataFilePath;
- (void)archiveSavingsData;

@end
