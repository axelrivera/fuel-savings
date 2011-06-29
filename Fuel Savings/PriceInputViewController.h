//
//  PriceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsData.h"

@interface PriceInputViewController : UIViewController {
	NSNumberFormatter *formatter_;
    NSInteger currencyScale_;
	SavingsData *savingsData_;
}

@property (nonatomic, retain) IBOutlet UITextField *inputTextField;
@property (nonatomic, copy) NSString *enteredDigits;
@property (nonatomic, copy) NSDecimalNumber *result;

@end
