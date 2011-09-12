//
//  MPGInputViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/1/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EfficiencyInputViewControllerDelegate;

typedef enum {
	EfficiencyInputTypeAverage,
	EfficiencyInputTypeCity,
	EfficiencyInputTypeHighway
} EfficiencyInputType;

@interface EfficiencyInputViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *efficiencyTextField_;
}

@property (nonatomic, assign) id <EfficiencyInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIToolbar *inputToolbar;
@property (nonatomic, assign) EfficiencyInputType currentType;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *enteredDigits;
@property (nonatomic, copy) NSNumber *currentEfficiency;
@property (nonatomic, copy) NSString *footerText;

- (IBAction)clearButtonAction:(id)sender;

@end

@protocol EfficiencyInputViewControllerDelegate

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save;

@end
