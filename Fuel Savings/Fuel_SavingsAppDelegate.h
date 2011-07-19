//
//  Fuel_SavingsAppDelegate.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fuel_SavingsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

- (NSString *)savingsDataFilePath;
- (void)archiveSavingsData;

- (NSString *)tripDataFielPath;
- (void)archiveTripData;

@end
