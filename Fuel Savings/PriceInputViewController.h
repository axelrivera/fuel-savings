//
//  PriceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceInputViewControllerDelegate;

@interface PriceInputViewController : UITableViewController <UITextFieldDelegate> {
	NSNumberFormatter *formatter_;
	UITextField *inputTextField_;
}

@property (nonatomic, assign) id <PriceInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIToolbar *inputToolbar;
@property (nonatomic, copy) NSString *enteredDigits;
@property (nonatomic, copy) NSDecimalNumber *currentPrice;
@property (nonatomic, copy) NSString *footerText;

- (IBAction)clearButtonAction:(id)sender;

@end

@protocol PriceInputViewControllerDelegate

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save;

@end
