//
//  DoubleButtonView.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DoubleButtonView.h"

@implementation DoubleButtonView

@synthesize leftButton = leftButton_;
@synthesize rightButton = rightButton_;

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithButtonType:UIButtonTypeRoundedRect frame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithButtonType:(UIButtonType)buttonType frame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		leftButton_ = [[UIButton buttonWithType:buttonType] retain];
		[self addSubview:leftButton_];
		
		rightButton_ = [[UIButton buttonWithType:buttonType] retain];
		[self addSubview:rightButton_];
	}
	return self;
}

- (void)dealloc
{
	[leftButton_ release];
	[rightButton_ release];
	[super dealloc];
}

- (void)layoutSubviews
{
	leftButton_.frame = CGRectMake(10.0,
								  20.0,
								  (self.frame.size.width / 2.0) - (10.0 + 5.0),
								  44.0);
	
	rightButton_.frame = CGRectMake((self.frame.size.width / 2.0) + 5.0,
								   20.0,
								   (self.frame.size.width / 2.0) - (10.0 + 5.0),
								   44.0);
}

@end
