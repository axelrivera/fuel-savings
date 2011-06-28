//
//  SingleInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameInputViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *inputTextField_;
	NSString *currentInput_;
}

@end
