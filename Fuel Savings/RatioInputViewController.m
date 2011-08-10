//
//  RatioInputViewController.m
//  Fuel Savings
//
//  Created by arn on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RatioInputViewController.h"

@implementation RatioInputViewController

@synthesize delegate = delegate_;
@synthesize currentCityRatio = currentCityRatio_;
@synthesize currentHighwayRatio = currentHighwayRatio_;
@synthesize footerText = footerText_;
@synthesize cityTitleLabel = cityTitleLabel_;
@synthesize cityLabel = cityLabel_;
@synthesize highwayTitleLabel = highwayTitleLabel_;
@synthesize highwayLabel = highwayLabel_;
@synthesize footerTextLabel = footerTextLabel_;
@synthesize cityAddButton = cityAddButton_;
@synthesize citySubtractButton = citySubtractButton_;
@synthesize highwayAddButton = highwayAddButton_;
@synthesize highwaySubtractButton = highwaySubtractButton_;
@synthesize highwaySlider = highwaySlider_;
@synthesize citySlider = citySlider_;


- (id)init
{
	self = [super initWithNibName:@"RatioInputViewController" bundle:nil];
	if (self) {
		numberFormatter_ = [[NSNumberFormatter alloc] init];
		[numberFormatter_ setNumberStyle:NSNumberFormatterPercentStyle];
		[numberFormatter_ setMaximumFractionDigits:0];
		
		self.currentCityRatio = [NSNumber numberWithFloat:0.5];
		self.currentHighwayRatio = [NSNumber numberWithFloat:0.5];
		self.footerText = nil;
	}
	return self;
}

- (void)dealloc
{
	[currentCityRatio_ release];
	[currentHighwayRatio_ release];
	[footerText_ release];
	[cityTitleLabel_ release];
	[cityLabel_ release];
	[highwayTitleLabel_ release];
	[highwayLabel_ release];
	[footerTextLabel_ release];
	[cityAddButton_ release];
	[citySubtractButton_ release];
	[highwayAddButton_ release];
	[highwaySubtractButton_ release];
	[citySlider_ release];
	[highwaySlider_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];	
	self.title = @"Driving Ratio";
	
	UIColor *gray = [UIColor darkGrayColor];
	UIColor *white = [UIColor whiteColor];
	UIColor *blue = [UIColor colorWithRed:57.0/255.0 green:85.0/255.0 blue:135.0/255.0 alpha:1.0];
	CGSize shadowSize = CGSizeMake(0.0, 1.0);
	
	self.cityTitleLabel.textColor = gray;
	self.cityTitleLabel.shadowColor = white;
	self.cityTitleLabel.shadowOffset = shadowSize;
	self.cityTitleLabel.text = @"City Ratio";
	
	self.cityLabel.textColor = blue;
	self.cityLabel.shadowColor = white;
	self.cityLabel.shadowOffset = shadowSize;
	
	self.highwayTitleLabel.textColor = gray;
	self.highwayTitleLabel.shadowColor = white;
	self.highwayTitleLabel.shadowOffset = shadowSize;
	self.highwayTitleLabel.text = @"Highway Ratio";
	
	self.highwayLabel.textColor = blue;
	self.highwayLabel.shadowColor = white;
	self.highwayLabel.shadowOffset = shadowSize;
	
	self.footerTextLabel.textColor = gray;
	self.footerTextLabel.shadowColor = white;
	self.footerTextLabel.shadowOffset = shadowSize;
	self.footerTextLabel.text = self.footerText;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.cityTitleLabel = nil;
	self.cityLabel = nil;
	self.highwayTitleLabel = nil;
	self.highwayLabel = nil;
	self.footerTextLabel = nil;
	self.cityAddButton = nil;
	self.citySubtractButton = nil;
	self.highwayAddButton = nil;
	self.highwaySubtractButton = nil;
	self.citySlider = nil;
	self.highwaySlider = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.citySlider setValue:[self.currentCityRatio floatValue] animated:NO];
	self.cityLabel.text = [numberFormatter_ stringFromNumber:self.currentCityRatio];
	
	[self.highwaySlider setValue:[self.currentHighwayRatio floatValue] animated:NO];
	self.highwayLabel.text = [numberFormatter_ stringFromNumber:self.currentHighwayRatio];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.delegate ratioInputViewControllerDidFinish:self save:YES];
}

#pragma mark - Custom Actions

- (IBAction)cityAddButtonAction:(id)sender
{
	
}

- (IBAction)citySubtractButtonAction:(id)sender
{
	
}

- (IBAction)highwayAddButtonAction:(id)sender
{
	
}

- (IBAction)highwaySubtractButtonAction:(id)sender
{
	
}

- (IBAction)citySliderAction:(id)sender
{
	self.currentCityRatio = [NSNumber numberWithFloat:[self.citySlider value]];
	self.cityLabel.text = [numberFormatter_ stringFromNumber:currentCityRatio_];
	
	self.currentHighwayRatio = [NSNumber numberWithFloat:1 - [self.currentCityRatio floatValue]];
	[self.highwaySlider setValue:[self.currentHighwayRatio floatValue] animated:YES];
	self.highwayLabel.text = [numberFormatter_ stringFromNumber:self.currentHighwayRatio];
}

- (IBAction)highwaySliderAction:(id)sender
{
	self.currentHighwayRatio = [NSNumber numberWithFloat:[self.highwaySlider value]];
	self.highwayLabel.text = [numberFormatter_ stringFromNumber:self.currentHighwayRatio];
	
	self.currentCityRatio = [NSNumber numberWithFloat:1 - [self.currentHighwayRatio floatValue]];
	[self.citySlider setValue:[self.currentCityRatio floatValue] animated:YES];
	self.cityLabel.text = [numberFormatter_ stringFromNumber:self.currentCityRatio];
}

@end
