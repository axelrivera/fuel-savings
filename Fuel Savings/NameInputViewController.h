//
//  SingleInputViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/28/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameInputViewControllerDelegate;

@interface NameInputViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *nameTextField_;
}

@property (nonatomic, assign) id <NameInputViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *currentName;
@property (nonatomic, copy) NSString *footerText;

- (void)displayNameError;

@end

@protocol NameInputViewControllerDelegate

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save;

@end
