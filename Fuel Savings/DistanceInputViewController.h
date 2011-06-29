//
//  DistanceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"

@interface DistanceInputViewController : UIViewController {
    NSArray *inputData_;
	NSNumberFormatter *numberFormatter_;
	SavingsData *savingsData;
}

@property (nonatomic, retain) IBOutlet UILabel *inputLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *inputPicker;
@property (nonatomic, copy) NSNumber *result;

@end
