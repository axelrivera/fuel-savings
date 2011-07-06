//
//  MPGInputViewController.h
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EfficiencyInputViewControllerDelegate;

typedef enum {
	EfficiencyInputTypeAverage,
	EfficiencyInputTypeCity,
	EfficiencyInputTypeHighway
} EfficiencyInputType;

@interface EfficiencyInputViewController : UIViewController {
    
}

@property (nonatomic, assign) id <EfficiencyInputViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *enteredDigits;
@property (nonatomic, copy) NSNumber *currentEfficiency;
@property (nonatomic) EfficiencyInputType currentType;
@property (nonatomic, retain) IBOutlet UITextField *efficiencyTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *clearButton;

- (IBAction)clearAction:(id)sender;

@end

@protocol EfficiencyInputViewControllerDelegate

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save;

@end
