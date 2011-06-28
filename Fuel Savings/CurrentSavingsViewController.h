//
//  CurrentSavingsViewController.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"
#import "SavingsCalculation.h"

@interface CurrentSavingsViewController : UIViewController {
	SavingsData *savingsData_;
}

@property (nonatomic, retain) IBOutlet UITableView *currentTable;

@end
