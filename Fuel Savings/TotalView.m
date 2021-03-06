//
//  TotalView.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/2/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "TotalView.h"

@interface TotalView (Private)

- (void)setImageView;
- (void)setTitleLabel;
- (void)setText1Label;
- (void)setText2Label;
- (void)setDetail1Label;
- (void)setDetail2Label;

- (UILabel *)commonLabel;

@end

@implementation TotalView

@synthesize imageView = imageView_;
@synthesize titleLabel = titleLabel_;
@synthesize text1Label = text1Label_;
@synthesize text2Label = text2Label_;
@synthesize detail1Label = detail1Label_;
@synthesize detail2Label = detail2Label_;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
		[self setImageView];
		[self setTitleLabel];
		[self setText1Label];
		[self setDetail1Label];
		[self setText2Label];
		[self setDetail2Label];
	}
	return self;
}

- (void)dealloc
{
	[imageView_ release];
	[titleLabel_ release];
	[text1Label_ release];
	[text2Label_ release];
	[detail1Label_ release];
	[detail2Label_ release];
	[super dealloc];
}

- (void)layoutSubviews
{
#define TEXT_LABEL_WIDTH 210
	
	self.imageView.frame = CGRectMake(10.0, 10.0, 24.0, 24.0);
	
	self.titleLabel.frame = CGRectMake(10.0 + 24.0 + 10.0,
									   10.0,
									   self.bounds.size.width - (10.0 + 24.0 + 10.0 + 10.0),
									   24.0);
	
	self.text1Label.frame = CGRectMake(10.0,
									   10.0 + 24.0 + 5.0,
									   TEXT_LABEL_WIDTH,
									   17.0);
	
	self.detail1Label.frame = CGRectMake(10.0 + TEXT_LABEL_WIDTH + 1.0,
										 10.0 + 24.0 + 5.0,
										 self.bounds.size.width - (10.0 + TEXT_LABEL_WIDTH + 1.0 + 10.0),
										 17.0);
	
	if (self.text2Label.hidden == NO && self.detail2Label.hidden == NO) {		
		self.text2Label.frame = CGRectMake(10.0,
										   10.0 + 24.0 + 5.0 + 17.0 + 5.0,
										   TEXT_LABEL_WIDTH,
										   17.0);
		
		self.detail2Label.frame = CGRectMake(10.0 + TEXT_LABEL_WIDTH + 1.0,
											 10.0 + 24.0 + 5.0 + 17.0 + 5.0,
											 self.bounds.size.width - (10.0 + TEXT_LABEL_WIDTH + 1.0 + 10.0),
											 17.0);
	}
}

#pragma mark - Custom Setters

- (void)setImageView
{
	[imageView_ autorelease];
	imageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
	imageView_.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:imageView_];
}

- (void)setTitleLabel
{
	[titleLabel_ autorelease];
	titleLabel_  = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel_.font = [UIFont systemFontOfSize:20.0];
	titleLabel_.backgroundColor = [UIColor clearColor];
	
	[self addSubview:titleLabel_];
}

- (void)setText1Label
{
	[text1Label_ autorelease];
	text1Label_ = [[self commonLabel] retain];
	[self addSubview:text1Label_];
}

- (void)setText2Label
{
	[text2Label_ autorelease];
	text2Label_ = [[self commonLabel] retain];
	text2Label_.hidden = YES;
	[self addSubview:text2Label_];
}

- (void)setDetail1Label
{
	[detail1Label_ autorelease];
	detail1Label_ = [[self commonLabel] retain];
	detail1Label_.textAlignment = UITextAlignmentRight;
	[self addSubview:detail1Label_];
}

- (void)setDetail2Label
{
	[detail2Label_ autorelease];
	detail2Label_ = [[self commonLabel] retain];
	detail2Label_.textAlignment = UITextAlignmentRight;
	detail2Label_.hidden = YES;
	[self addSubview:detail2Label_];
}


- (UILabel *)commonLabel
{
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.font = [UIFont systemFontOfSize:16.0];
	label.lineBreakMode = UILineBreakModeTailTruncation;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor darkGrayColor];
	return label;
}

@end
