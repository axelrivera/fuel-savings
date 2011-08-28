//
//  TypeInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeInputViewControllerDelegate;

@interface TypeInputViewController : UIViewController {
	NSNumberFormatter *percentFormatter_;
}

@property (nonatomic, assign) id <TypeInputViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentType;
@property (nonatomic, copy) NSNumber *currentCityRatio;
@property (nonatomic, copy) NSNumber *currentHighwayRatio;

@property (nonatomic, retain) IBOutlet UISegmentedControl *typeSegmentedControl;

@property (nonatomic, retain) IBOutlet UILabel *headerTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *footerTextLabel;

@property (nonatomic, retain) IBOutlet UILabel *cityTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *highwayTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *highwayLabel;

@property (nonatomic, retain) IBOutlet UIButton *cityAddButton;
@property (nonatomic, retain) IBOutlet UIButton *citySubtractButton;
@property (nonatomic, retain) IBOutlet UIButton *highwayAddButton;
@property (nonatomic, retain) IBOutlet UIButton *highwaySubtractButton;

@property (nonatomic, retain) IBOutlet UISlider *citySlider;
@property (nonatomic, retain) IBOutlet UISlider *highwaySlider;

- (IBAction)typeSegmentedControlAction:(id)sender;

- (IBAction)cityAddButtonAction:(id)sender;
- (IBAction)citySubtractButtonAction:(id)sender;
- (IBAction)highwayAddButtonAction:(id)sender;
- (IBAction)highwaySubtractButtonAction:(id)sender;

- (IBAction)citySliderAction:(id)sender;
- (IBAction)highwaySliderAction:(id)sender;

@end

@protocol TypeInputViewControllerDelegate

- (void)typeInputViewControllerDidFinish:(TypeInputViewController *)controller save:(BOOL)save;

@end
