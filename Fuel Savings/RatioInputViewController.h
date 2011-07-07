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
@property (nonatomic, retain) IBOutlet UISlider *citySlider;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UISlider *highwaySlider;
@property (nonatomic, retain) IBOutlet UILabel *highwayLabel;

- (IBAction)citySliderAction:(id)sender;
- (IBAction)highwaySliderAction:(id)sender;

@end

@protocol RatioInputViewControllerDelegate

- (void)ratioInputViewControllerDidFinish:(RatioInputViewController *)controller save:(BOOL)save;

@end
