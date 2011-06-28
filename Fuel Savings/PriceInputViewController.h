//
//  PriceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PriceInputViewController : UIViewController {
	NSNumberFormatter *formatter_;
    NSInteger currencyScale_;
}

@property (nonatomic, retain) IBOutlet UITextField *inputTextField;
@property (nonatomic, retain) NSString *enteredDigits;
@property (nonatomic, copy) NSDecimalNumber *result;

@end
