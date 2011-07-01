//
//  DistanceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DistanceInputViewControllerDelegate;

@interface DistanceInputViewController : UIViewController {
    NSArray *inputData_;
	NSNumberFormatter *numberFormatter_;
}

@property (nonatomic, assign) id <DistanceInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *inputLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *inputPicker;
@property (nonatomic, copy) NSNumber *currentDistance;

@end

@protocol DistanceInputViewControllerDelegate

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save;

@end
