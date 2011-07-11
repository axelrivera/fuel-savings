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
@synthesize citySlider = citySlider_;
@synthesize cityLabel = cityLabel_;
@synthesize highwaySlider = highwaySlider_;
@synthesize highwayLabel = highwayLabel_;

- (id)init
{
	self = [super initWithNibName:@"RatioInputViewController" bundle:nil];
	if (self) {
		numberFormatter_ = [[NSNumberFormatter alloc] init];
		[numberFormatter_ setNumberStyle:NSNumberFormatterPercentStyle];
		[numberFormatter_ setMaximumFractionDigits:0];
		
		self.currentCityRatio = [NSNumber numberWithFloat:0.5];
		self.currentHighwayRatio = [NSNumber numberWithFloat:0.5];
	}
	return self;
}

- (void)dealloc
{
	[currentCityRatio_ release];
	[currentHighwayRatio_ release];
	[citySlider_ release];
	[cityLabel_ release];
	[highwaySlider_ release];
	[highwayLabel_ release];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.citySlider = nil;
	self.cityLabel = nil;
	self.highwaySlider = nil;
	self.highwayLabel = nil;
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
