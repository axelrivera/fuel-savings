//
//  DistanceInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { DistanceInputTypeSavings, DistanceInputTypeTrip } DistanceInputType;

@protocol DistanceInputViewControllerDelegate;

@interface DistanceInputViewController : UIViewController {
    NSArray *inputData_;
	NSNumberFormatter *numberFormatter_;
	DistanceInputType type_;
	NSInteger distanceFactor_;
}

@property (nonatomic, assign) id <DistanceInputViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *inputLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *inputPicker;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *substractButton;
@property (nonatomic, copy) NSNumber *currentDistance;

- (id)initWithType:(DistanceInputType)type;

@end

@protocol DistanceInputViewControllerDelegate

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save;

@end
