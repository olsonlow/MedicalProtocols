//
//  ComponentModalViewController.m
//  MedicalProtocols
//
//  Created by Lowell D. Olson on 4/18/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentModalViewController.h"
#import "Component.h"
#import "EditableProperty.h"
#import "BoolEditableProperty.h"
#import "TextEditableProperty.h"

#import "TextFieldPropertyCell.m"
#import "TextAreaPropertyCell.h"
#import "SwitchPropertyCell.h"

@interface ComponentModalViewController ()

@end

@implementation ComponentModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.component countEditableProperties];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditableProperty* editableProperty = [self.component editablePropertyAtIndex:indexPath.row];
    UITableViewCell* cell = nil;
    if([editableProperty isKindOfClass:[TextEditableProperty class]]){
        TextEditableProperty* textProperty = (TextEditableProperty*)editableProperty;
        if(textProperty.isTextArea){
            TextAreaPropertyCell* textAreaCell = [self.tableView dequeueReusableCellWithIdentifier:@"TextAreaPropertyCell" forIndexPath:indexPath];
            textAreaCell.label.text = textProperty.name;
            textAreaCell.textArea.text = textProperty.value;
            cell = textAreaCell;
        }else{
            TextFieldPropertyCell* textFieldCell = [self.tableView dequeueReusableCellWithIdentifier:@"TextFieldPropertyCell" forIndexPath:indexPath];
            textFieldCell.label.text = textProperty.name;
            textFieldCell.textField.text = textProperty.value;
            cell = textFieldCell;
        }
    } else if([editableProperty isKindOfClass:[BoolEditableProperty class]]){
        BoolEditableProperty* boolProperty = (BoolEditableProperty*)editableProperty;
        SwitchPropertyCell* switchCell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchPropertyCell" forIndexPath:indexPath];
        switchCell.label.text = boolProperty.name;
        cell = switchCell;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditableProperty* editableProperty = [self.component editablePropertyAtIndex:indexPath.row];
    if([editableProperty isKindOfClass:[TextEditableProperty class]]){
        TextEditableProperty* textProperty = (TextEditableProperty*)editableProperty;
        if(textProperty.isTextArea){
            return 103;
        }
    }
    return 44;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveComponentProperties:(id)sender {
    
    
}
@end
