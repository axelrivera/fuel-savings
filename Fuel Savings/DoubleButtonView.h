//
//  DoubleButtonView.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleButtonView : UIView

@property (nonatomic, retain, readonly) UIButton *leftButton;
@property (nonatomic, retain, readonly) UIButton *rightButton;

- (id)initWithButtonType:(UIButtonType)buttonType frame:(CGRect)frame;

@end
