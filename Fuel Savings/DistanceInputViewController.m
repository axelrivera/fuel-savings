//
//  DistanceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DistanceInputViewController.h"

#define MIN_DISTANCE 0
#define MAX_DISTANCE 99999
#define SAVINGS_FACTOR 1000
#define TRIP_FACTOR 100

@interface DistanceInputViewController (Private)

- (void)setInputPickerWithNumber:(NSNumber *)number animated:(BOOL)animated;

@end

@implementation DistanceInputViewController

@synthesize delegate = delegate_;
@synthesize inputLabel = inputLabel_;
@synthesize inputPicker = inputPicker_;
@synthesize addButton = addButton_;
@synthesize substractButton = substractButton_;
@synthesize currentDistance = currentDistance_;

- (id)init
{
	self = [super initWithNibName:@"DistanceInputViewController" bundle:nil];
	if (self) {
		NSMutableArray *input = [[NSMutableArray alloc] initWithCapacity:10];
		for (NSInteger i = 0; i < 10; i++) {
			[input addObject:[NSNumber numberWithInteger:i]];
		}
		
		inputData_ = [[NSArray alloc] initWithObjects:
					  [NSArray arrayWithArray:input],
					  [NSArray arrayWithArray:input],
					  [NSArray arrayWithArray:input],
					  [NSArray arrayWithArray:input],
					  [NSArray arrayWithArray:input],
					  nil];
		
		[input release];
		
		numberFormatter_ = [[NSNumberFormatter alloc] init];
		[numberFormatter_ setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter_ setMaximumFractionDigits:0];
				
		type_ = DistanceInputTypeSavings;
		distanceFactor_ = SAVINGS_FACTOR;
		
		self.currentDistance = [NSNumber numberWithInteger:15000];
	}
	return self;
}

- (id)initWithType:(DistanceInputType)type
{
	self = [self init];
	if (self) {
		if (type == DistanceInputTypeTrip) {
			type_ = type;
			distanceFactor_ = TRIP_FACTOR;
		}
	}
	return self;
}

- (void)dealloc
{
	[inputData_ release];
	[numberFormatter_ release];
	[inputLabel_ release];
	[inputPicker_ release];
	[addButton_ release];
	[substractButton_ release];
	[currentDistance_ release];
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
	self.title = @"Change Distance";
	
	[self.addButton addTarget:self
					   action:@selector(addAction)
			 forControlEvents:UIControlEventTouchDown];
	
	
	NSNumber *numberFactor = [NSNumber numberWithInteger:distanceFactor_];
	
	[self.addButton setTitle:[NSString stringWithFormat:@"Add %@", [numberFormatter_ stringFromNumber:numberFactor]]
					forState:UIControlStateNormal];
	
	[self.substractButton addTarget:self
							 action:@selector(substractAction)
				   forControlEvents:UIControlEventTouchDown];
	
	[self.substractButton setTitle:[NSString stringWithFormat:@"Substract %@", [numberFormatter_ stringFromNumber:numberFactor]]
						  forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.inputLabel = nil;
	self.inputPicker = nil;
	self.addButton = nil;
	self.substractButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setInputPickerWithNumber:self.currentDistance animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.delegate distanceInputViewControllerDidFinish:self save:YES];
}

# pragma mark - Custom Actions

- (void)addAction
{
	NSInteger result = [self.currentDistance integerValue] + distanceFactor_;
	
	if (result > MAX_DISTANCE) {
		result = MAX_DISTANCE;
	}
	
	self.currentDistance = [NSNumber numberWithInteger:result];
	[self setInputPickerWithNumber:self.currentDistance animated:YES];
}

- (void)substractAction
{
	NSInteger result = [self.currentDistance integerValue] - distanceFactor_;
	
	if (result < MIN_DISTANCE) {
		result = MIN_DISTANCE;
	}
	
	self.currentDistance = [NSNumber numberWithInteger:result];
	[self setInputPickerWithNumber:self.currentDistance animated:YES];
}

#pragma mark - Private Methods

- (void)setInputPickerWithNumber:(NSNumber *)number animated:(BOOL)animated
{
	NSNumberFormatter *stringFormatter = [[NSNumberFormatter alloc] init];
	[stringFormatter setNumberStyle:NSNumberFormatterNoStyle];
	[stringFormatter setMinimumFractionDigits:0];
	[stringFormatter setFormatWidth:5];
	[stringFormatter setPaddingCharacter:@"0"];
	
	
	NSString *numberString = [stringFormatter stringFromNumber:number];
	
	[stringFormatter release];
	
	for (NSInteger i = 0; i < [self.inputPicker numberOfComponents]; i++) {
		NSString *string = [numberString substringWithRange:NSMakeRange(i, 1)];
		NSNumber *tmpNumber = [numberFormatter_ numberFromString:string];
		NSInteger position =  [tmpNumber integerValue];
		[self.inputPicker selectRow:position inComponent:i animated:animated];
		self.inputLabel.text = [NSString stringWithFormat:@"%@ miles/year", [numberFormatter_ stringFromNumber:number]];
	}
}

# pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[inputData_ objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSArray *array = [inputData_ objectAtIndex:component];
	return [numberFormatter_ stringFromNumber:[array objectAtIndex:row]];
}

#pragma UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 50.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString *distanceString = @"";
	
	for (NSInteger i = 0; i < [pickerView numberOfComponents]; i++) {
		NSArray *array = [inputData_ objectAtIndex:i];
		NSNumber *number = [array objectAtIndex:[pickerView selectedRowInComponent:i]];
		distanceString = [distanceString stringByAppendingFormat:@"%@", [number stringValue]];
	}
	
	self.currentDistance = [numberFormatter_ numberFromString:distanceString];
	self.inputLabel.text = [NSString stringWithFormat:@"%@ miles/year", [numberFormatter_ stringFromNumber:self.currentDistance]];
}

@end
