//
//  SingleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameInputViewController.h"

@implementation NameInputViewController

@synthesize delegate = delegate_;
@synthesize key = key_;
@synthesize currentName = currentName_;

- (id)init
{
	self = [super initWithNibName:@"NameInputViewController" bundle:nil];
	if (self) {
		self.key = @"";
		self.currentName = @"";
	}
	return self;
}

- (void)dealloc
{
	[key_ release];
	[currentName_ release];
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

	nameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 280.0, 30.0)];
	nameTextField_.font = [UIFont systemFontOfSize:16.0];
	nameTextField_.adjustsFontSizeToFitWidth = YES;
	nameTextField_.placeholder = @"Name";
	nameTextField_.keyboardType = UIKeyboardTypeDefault;
	nameTextField_.returnKeyType = UIReturnKeyDone;
	nameTextField_.autocorrectionType = UITextAutocorrectionTypeNo;
	nameTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	nameTextField_.textAlignment = UITextAlignmentLeft;
	nameTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	nameTextField_.clearButtonMode = YES;
	nameTextField_.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[nameTextField_ release];
	nameTextField_ = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	nameTextField_.text = self.currentName;
	[nameTextField_ becomeFirstResponder];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	self.currentName = nameTextField_.text;
	[self.delegate nameInputViewControllerDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate nameInputViewControllerDidFinish:self save:NO];
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    cell.accessoryView = nameTextField_;
	
    return cell;
}

@end
