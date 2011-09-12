//
//  CountriesViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface CountriesViewController : UITableViewController {
	Settings *settings_;
}

@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, assign) NSInteger currentCountry;

@end
