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

#import "BasePropertyCell.h"
#import "TextFieldPropertyCell.m"
#import "TextAreaPropertyCell.h"
#import "SwitchPropertyCell.h"

#import "TextBlock.h"
#import "Link.h"
#import "Calculator.h"
#import "Form.h"

#import "DataSource.h"

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"FormSheetUnwindSave"]){
        [self saveComponentProperties];
    }
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
    cell.tag = indexPath.row;
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

- (void)saveComponentProperties {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            [cells addObject:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
        }
    }
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (BasePropertyCell *cell in cells)
    {
        [values addObject:cell.value];
    }
    switch (self.component.componentType) {
        case ComponentTypeTextBlock:
            [self insertValues:values IntoTextBlock:(TextBlock*)self.component];
            break;
        case ComponentTypeLink:
            [self insertValues:values IntoLink:(Link*)self.component];
            break;
        case ComponentTypeForm:
            [self insertValues:values IntoForm:(Form*)self.component];
            break;
        case ComponentTypeCalculator:
            [self insertValues:values IntoCalculator:(Calculator*)self.component];
            break;
        default:
            break;
    }
    [[DataSource sharedInstance] updateObjectWithDataType:DataTypeComponent withId:self.component.objectId withObject:self.component];
}
-(void)insertValues:(NSMutableArray*)values IntoTextBlock:(TextBlock*)textBlock{
    textBlock.title = [values objectAtIndex:0];
    textBlock.content = [values objectAtIndex:1];
    textBlock.printable = [[values objectAtIndex:2] boolValue];
}
-(void)insertValues:(NSMutableArray*)values IntoForm:(Form*)form{
    
}
-(void)insertValues:(NSMutableArray*)values IntoLink:(Link*)link{
    link.label = [values objectAtIndex:0];
    link.url = [values objectAtIndex:1];
}
-(void)insertValues:(NSMutableArray*)values IntoCalculator:(Calculator*)calculator{

}
@end
