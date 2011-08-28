//
//  DetailView.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailView.h"

NSString * const kDetailViewTextKey = @"DetailSummaryViewTextKey";
NSString * const kDetailViewDetailKey = @"DetailSummaryViewDetailKey";

@implementation DetailView

@synthesize text = text_;
@synthesize detail = detail_;
@synthesize textLabel = textLabel_;
@synthesize detailTextLabel = detailTextLabel_;

+ (NSDictionary *)detailDictionaryWithText:(NSString *)text detail:(NSString *)detail
{
	NSDictionary *details = [NSDictionary dictionaryWithObjectsAndKeys:
													 text, kDetailViewTextKey,
													 detail, kDetailViewDetailKey,
													 nil];
	return details;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [self initWithText:[dictionary objectForKey:kDetailViewTextKey]
										 detail:[dictionary objectForKey:kDetailViewDetailKey]];
	if	(self) {
		// Initialization Code
	}
	return self;
}

- (id)initWithText:(NSString *)text detail:(NSString *)detail
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.opaque = YES;
		
		textFont_ = [[UIFont systemFontOfSize:12.0] retain];
		detailFont_ = [[UIFont systemFontOfSize:12.0] retain];
		
		text_ = [text retain];
		detail_ = [detail retain];
		
		textLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel_.font = textFont_;
		textLabel_.backgroundColor = [UIColor clearColor];
		textLabel_.textColor = [UIColor blackColor];
		textLabel_.textAlignment = UITextAlignmentLeft;
		textLabel_.lineBreakMode = UILineBreakModeTailTruncation;
		textLabel_.adjustsFontSizeToFitWidth = NO;
		textLabel_.text = text_;
		
		[self addSubview:textLabel_];
		
		detailTextLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		detailTextLabel_.font = detailFont_;
		detailTextLabel_.backgroundColor = [UIColor clearColor];
		detailTextLabel_.textColor = [UIColor darkGrayColor];
		detailTextLabel_.textAlignment = UITextAlignmentRight;
		detailTextLabel_.lineBreakMode = UILineBreakModeHeadTruncation;
		detailTextLabel_.adjustsFontSizeToFitWidth = NO;
		detailTextLabel_.text = detail_;
		
		[self addSubview:detailTextLabel_];
	}
	return self;
}

- (void)dealloc
{
	[textFont_ release];
	[detailFont_ release];
	[text_ release];
	[detail_ release];
	[textLabel_ release];
	[detailTextLabel_ release];
	[super dealloc];
}

- (void)layoutSubviews
{
#define PADDING 3.0
#define HORIZONTAL_OFFSET 2.0
	
	CGSize textLabelSize = [text_ sizeWithFont:textFont_];
	
	if (textLabelSize.width >= self.frame.size.width) {
		textLabelSize.width = (self.frame.size.width / 2.0) - HORIZONTAL_OFFSET;
	}
	
	self.frame = CGRectMake(self.frame.origin.x,
													self.frame.origin.y,
													self.superview.frame.size.width - (10.0 + 10.0),
													DETAIL_VIEW_HEIGHT);
	
	textLabel_.frame = CGRectMake(PADDING,
																0.0,
																textLabelSize.width,
																DETAIL_VIEW_HEIGHT);
	
	detailTextLabel_.frame = CGRectMake(PADDING + textLabelSize.width + HORIZONTAL_OFFSET,
																			0.0,
																			self.frame.size.width - (PADDING + textLabelSize.width + HORIZONTAL_OFFSET + PADDING),
																			DETAIL_VIEW_HEIGHT);
}

- (void)setText:(NSString *)text detail:(NSString *)detail
{
	[text_ autorelease];
	text_ = [text retain];
	
	[detail_ autorelease];
	detail_ = [detail retain];
	[self setNeedsDisplay];
}

- (NSDictionary *)detailDictionary
{
	return [DetailView detailDictionaryWithText:self.text detail:self.detail];
}

@end
