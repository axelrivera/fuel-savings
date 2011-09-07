//
//  RLTopBarView.m
//  Fuel Savings
//
//  Created by Axel Rivera on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLTopBarView.h"

@implementation RLTopBarView

@synthesize titleLabel = titleLabel_;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.opaque = YES;
		self.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0];
		
		[self setFrame:frame];
		
		titleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel_.font = [UIFont systemFontOfSize:15.0];
		titleLabel_.textAlignment = UITextAlignmentCenter;
		titleLabel_.numberOfLines = 2;
		titleLabel_.minimumFontSize = 10.0;
		titleLabel_.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel_.backgroundColor = [UIColor clearColor];
		titleLabel_.textColor = [UIColor darkGrayColor];
		titleLabel_.shadowColor = [UIColor whiteColor];
		titleLabel_.shadowOffset = CGSizeMake(0.0, 1.0);
		
		titleLabel_.frame = CGRectMake(10.0,
									   5.0,
									   self.frame.size.width - 20.0,
									   self.frame.size.height - 10.0);
		
		[self addSubview:titleLabel_];
	}
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.5].CGColor);
	CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 0.0, 0.0); //start at this point
    CGContextAddLineToPoint(context, self.frame.size.width, 0.0); //draw to this point
	CGContextStrokePath(context);
	
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
	CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 0.0, self.frame.size.height); //start at this point
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height); //draw to this point
    CGContextStrokePath(context);
}

- (void)setFrame:(CGRect)frame
{
	CGRect newframe = CGRectMake(frame.origin.x,
								 frame.origin.y,
								 [UIScreen mainScreen].bounds.size.width,
								 44.0);
	[super setFrame:newframe];
}

- (void)dealloc
{
	[titleLabel_ release];
	[super dealloc];
}

@end
