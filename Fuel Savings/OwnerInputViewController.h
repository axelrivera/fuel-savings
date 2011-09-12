//
//  OwnerInputViewController.h
//  Fuel Savings
//
//  Created by Axel Rivera on 6/29/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OwnerInputViewControllerDelegate;

@interface OwnerInputViewController : UIViewController {
	NSArray *inputData_;
}

@property (nonatomic, assign) id <OwnerInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *ownerTable;
@property (nonatomic, retain) IBOutlet UIPickerView *inputPicker;
@property (nonatomic, copy) NSNumber *currentOwnership;
@property (nonatomic, copy) NSString *footerText;

@end

@protocol  OwnerInputViewControllerDelegate

- (void)ownerInputViewControllerDidFinish:(OwnerInputViewController *)controller save:(BOOL)save;

@end
