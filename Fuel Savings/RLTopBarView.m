//
//  RLTopBarView.m
//  Fuel Savings
//
//  Created by Axel Rivera on 9/6/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "RLTopBarView.h"

@implementation RLTopBarView

@synthesize titleLabel = titleLabel_;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.opaque = YES;
		self.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:183.0/255.0 blue:191.0/255.0 alpha:1.0];
		
		gradientLayer_ = [[CAGradientLayer layer] retain];
		
		gradientLayer_.colors = [NSArray arrayWithObjects:
								 (id)[UIColor colorWithWhite:1.0f alpha:0.7f].CGColor,
								 (id)[UIColor colorWithWhite:0.9f alpha:0.3].CGColor,
								 (id)[UIColor colorWithWhite:0.9f alpha:0.2f].CGColor,
								 (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
								 (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
								 (id)[UIColor colorWithWhite:0.2f alpha:0.1f].CGColor,
								 nil];
		
		gradientLayer_.locations = [NSArray arrayWithObjects:
									[NSNumber numberWithFloat:0.0f],
									[NSNumber numberWithFloat:0.05f],
									[NSNumber numberWithFloat:0.5f],
									[NSNumber numberWithFloat:0.5f],
									[NSNumber numberWithFloat:0.8f],
									[NSNumber numberWithFloat:1.0f],
									nil];
		
		[self.layer addSublayer:gradientLayer_];
		
		[self setFrame:frame];
		
		titleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel_.font = [UIFont boldSystemFontOfSize:14.0];
		titleLabel_.textAlignment = UITextAlignmentCenter;
		titleLabel_.numberOfLines = 2;
		titleLabel_.minimumFontSize = 10.0;
		titleLabel_.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel_.backgroundColor = [UIColor clearColor];
		titleLabel_.textColor = [UIColor colorWithRed:57.0/255.0 green:85.0/255.0 blue:135.0/255.0 alpha:1.0];
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
	
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:137.0/255.0 green:153.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor);
	CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 0.0, self.frame.size.height); //start at this point
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height); //draw to this point
    CGContextStrokePath(context);
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	gradientLayer_.frame = self.layer.bounds;
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
	[gradientLayer_ release];
	[titleLabel_ release];
	[super dealloc];
}

@end
