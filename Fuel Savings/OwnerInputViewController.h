//
//  OwnerInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OwnerInputViewControllerDelegate;

@interface OwnerInputViewController : UIViewController {
	NSArray *inputData_;
}

@property (nonatomic, assign) id <OwnerInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *inputLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *inputPicker;
@property (nonatomic, copy) NSNumber *currentOwnership;

@end

@protocol  OwnerInputViewControllerDelegate

- (void)ownerInputViewControllerDelegate:(OwnerInputViewController *)controller save:(BOOL)save;

@end
