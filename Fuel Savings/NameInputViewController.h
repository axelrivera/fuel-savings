//
//  SingleInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameInputViewControllerDelegate;

@interface NameInputViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *nameTextField_;
}

@property (nonatomic, assign) id <NameInputViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *currentName;

@end

@protocol NameInputViewControllerDelegate

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save;

@end
