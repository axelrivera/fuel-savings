//
//  PriceInputViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/28/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
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
@property (nonatomic, copy) NSString *key;

- (IBAction)clearButtonAction:(id)sender;

@end

@protocol PriceInputViewControllerDelegate

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save;

@end
