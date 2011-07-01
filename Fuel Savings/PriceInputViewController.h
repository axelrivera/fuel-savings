//
//  PriceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceInputViewControllerDelegate;

@interface PriceInputViewController : UIViewController {
	NSNumberFormatter *formatter_;
    NSInteger currencyScale_;
}

@property (nonatomic, assign) id <PriceInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *inputTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *clearButton;
@property (nonatomic, copy) NSString *enteredDigits;
@property (nonatomic, copy) NSDecimalNumber *currentPrice;

- (IBAction)clearAction:(id)sender;

@end

@protocol PriceInputViewControllerDelegate

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save;

@end
