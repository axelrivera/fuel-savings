//
//  RLTopBarView.h
//  Fuel Savings
//
//  Created by Axel Rivera on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RLTopBarView : UIView {
	CAGradientLayer *gradientLayer_;
}

@property (nonatomic, retain, readonly) UILabel *titleLabel;

@end
