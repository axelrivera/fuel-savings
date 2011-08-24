//
//  RLCustomButton.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RLCustomButton : UIButton {
    CAGradientLayer *gradientLayer_;
    CALayer         *highlightLayer_;
}

+ (RLCustomButton *)customButton;

@end
