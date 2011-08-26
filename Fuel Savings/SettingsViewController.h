//
//  SettingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SettingsViewController : UIViewController <ADBannerViewDelegate> {
	ADBannerView *adBanner_;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *settingsTable;
@property (nonatomic, retain) NSArray *settingsData;

- (id)initWithTabBar;

@end
