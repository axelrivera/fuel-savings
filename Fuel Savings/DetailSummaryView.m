//
//  DetailSummaryView.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailSummaryView.h"
#import "DetailView.h"

@implementation DetailSummaryView

@synthesize oddColor = oddColor_;
@synthesize evenColor = evenColor_;
@synthesize labels = labels_;
@synthesize details = details_;
@synthesize imageView = imageView_;
@synthesize titleLabel = titleLabel_;

- (id)initWithLabels:(NSArray *)labels details:(NSArray *)details
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		NSAssert([labels count] == [details count], @"Labels and Details must have the same size");
		
		self.opaque = YES;
		
		self.oddColor = [UIColor clearColor];
		self.evenColor = [UIColor lightGrayColor];
		
		labels_ = [labels retain];
		details_ = [details retain];
		
		imageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView_.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:imageView_];
		
		NSInteger totalViews = [labels count];
		
		detailViews_ = [[NSMutableArray alloc] initWithCapacity:totalViews];
		
		for (NSInteger i = 0; i < totalViews; i++) {
			DetailView *detailsView = [[[DetailView alloc] initWithText:[labels_ objectAtIndex:i]
															  detail:[details_ objectAtIndex:i]] autorelease];
			
			if ((i % 2) == 0) {
				detailsView.backgroundColor = evenColor_;
			} else {
				detailsView.backgroundColor = oddColor_;
			}
			
			[detailViews_ addObject:detailsView];
			[self addSubview:detailsView];
		}
	}
	return self;
}

- (void)dealloc
{
	[oddColor_ release];
	[evenColor_ release];
	[labels_ release];
	[details_ release];
	[imageView_ release];
	[titleLabel_ release];
	[detailViews_ release];
	[super dealloc];
}

- (void)layoutSubviews
{
#define VERTICAL_OFFSET 5.0
	CGFloat detailY = 15.0;
	
	self.imageView.frame = CGRectMake(10.0, 10.0, 24.0, 24.0);
	
	self.titleLabel.frame = CGRectMake(10.0 + 24.0 + 10.0,
									   10.0,
									   self.bounds.size.width - (10.0 + 24.0 + 10.0 + 10.0),
									   24.0);
	
	NSInteger totalViews = [detailViews_ count];
	
	for (NSInteger i = 0; i < totalViews; i++) {
		DetailView *detailView = [detailViews_ objectAtIndex:i];
		
		detailView.frame = CGRectMake(10.0,
									  detailY,
									  self.bounds.size.width - (10.0 + 10.0),
									  detailView.frame.size.height);
		
		detailY = detailY + detailView.frame.size.height + VERTICAL_OFFSET;
	}
}

- (NSArray *)detailViews
{
	return detailViews_;
}

@end