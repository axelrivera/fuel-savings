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
@property (nonatomic, retain) IBOutlet UITableView *distanceTable;
@property (nonatomic, retain) IBOutlet UIPickerView *inputPicker;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *subtractButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *resetButton;
@property (nonatomic, copy) NSNumber *currentDistance;
@property (nonatomic, copy) NSString *distanceSuffix;
@property (nonatomic, copy) NSString *footerText;

- (id)initWithType:(DistanceInputType)type;

- (IBAction)addAction:(id)sender;
- (IBAction)subtractAction:(id)sender;
- (IBAction)resetAction:(id)sender;

@end

@protocol DistanceInputViewControllerDelegate

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save;

@end
