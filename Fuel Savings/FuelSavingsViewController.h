//
//  FuelSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLTopToolbar.h"
#import "NewSavingsViewController.h"
#import "SavingsData.h"

@interface FuelSavingsViewController : UIViewController <NewSavingsViewControllerDelegate> {
	SavingsData *savingsData_;
}

- (id)initWithTabBar;

@end
