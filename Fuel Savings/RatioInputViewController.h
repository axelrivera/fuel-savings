//
//  RatioInputViewController.h
//  Fuel Savings
//
//  Created by arn on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatioInputViewControllerDelegate;

@interface RatioInputViewController : UIViewController {
    NSNumberFormatter *numberFormatter_;
}

@property (nonatomic, assign) id <RatioInputViewControllerDelegate> delegate;

@property (nonatomic, copy) NSNumber *currentCityRatio;
@property (nonatomic, copy) NSNumber *currentHighwayRatio;
@property (nonatomic, copy) NSString *footerText;

@property (nonatomic, retain) IBOutlet UILabel *cityTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *highwayTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *highwayLabel;
@property (nonatomic, retain) IBOutlet UILabel *footerTextLabel;

@property (nonatomic, retain) IBOutlet UIButton *cityAddButton;
@property (nonatomic, retain) IBOutlet UIButton *citySubtractButton;
@property (nonatomic, retain) IBOutlet UIButton *highwayAddButton;
@property (nonatomic, retain) IBOutlet UIButton *highwaySubtractButton;

@property (nonatomic, retain) IBOutlet UISlider *highwaySlider;
@property (nonatomic, retain) IBOutlet UISlider *citySlider;

- (IBAction)cityAddButtonAction:(id)sender;
- (IBAction)citySubtractButtonAction:(id)sender;
- (IBAction)highwayAddButtonAction:(id)sender;
- (IBAction)highwaySubtractButtonAction:(id)sender;

- (IBAction)citySliderAction:(id)sender;
- (IBAction)highwaySliderAction:(id)sender;

@end

@protocol RatioInputViewControllerDelegate

- (void)ratioInputViewControllerDidFinish:(RatioInputViewController *)controller save:(BOOL)save;

@end
