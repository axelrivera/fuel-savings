//
//  SingleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameInputViewController.h"
#import "SavingsData.h"

@implementation NameInputViewController

- (id)init
{
	self = [super initWithNibName:@"NameInputViewController" bundle:nil];
	if (self) {
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																					  target:self
																					  action:@selector(dismissAction)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					target:self
																					action:@selector(doneAction)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
	}
	return self;
}

- (void)dealloc
{
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

	inputTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 280.0, 30.0)];
	inputTextField_.font = [UIFont systemFontOfSize:16.0];
	inputTextField_.adjustsFontSizeToFitWidth = YES;
	inputTextField_.placeholder = @"Name";
	inputTextField_.keyboardType = UIKeyboardTypeDefault;
	inputTextField_.returnKeyType = UIReturnKeyDone;
	inputTextField_.autocorrectionType = UITextAutocorrectionTypeNo;
	inputTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	inputTextField_.textAlignment = UITextAlignmentLeft;
	inputTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	inputTextField_.clearButtonMode = YES;
	inputTextField_.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[inputTextField_ release];
	inputTextField_ = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[inputTextField_ becomeFirstResponder];
	inputTextField_.text = [SavingsData sharedSavingsData].currentCalculation.name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[SavingsData sharedSavingsData].currentCalculation.name = inputTextField_.text;
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self performSelector:@selector(doneAction)];
	return NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = inputTextField_;
	
    return cell;
}

@end
