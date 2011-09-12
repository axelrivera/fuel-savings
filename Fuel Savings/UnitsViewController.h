//
//  UnitsViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/17/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface UnitsViewController : UITableViewController {
	Settings *settings_;
	NSArray *distanceUnits_;
	NSArray *volumeUnits_;
	NSArray *efficiencyUnits_;
}

@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, assign) NSInteger currentDistance;
@property (nonatomic, assign) NSInteger currentVolume;
@property (nonatomic, assign) NSInteger currentEfficiency;

@end
