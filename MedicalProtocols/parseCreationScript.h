////TODO update parse backend by re-running below code
//
//PFObject *protocol = [PFObject objectWithClassName:@"Protocol"];
//protocol[@"name"] = @"Atrial Fibrillation";
//protocol[@"databaseId"] = [NSNumber numberWithInt:0];
//[protocol saveInBackground];
//
////        PFObject *component= [PFObject objectWithClassName:@"Component"];
////        component[@"color"] = @"0, 214, 132";
//PFObject *stepObject = [PFObject objectWithClassName:@"Step"];
//stepObject[@"stepNumber"] = [NSNumber numberWithInt:1];
//stepObject[@"description"] = @"Decision Regarding Anticoagulation:";
//stepObject[@"databaseId"] = [NSNumber numberWithInt:0];
//stepObject[@"protocolDatabaseId"] = protocol[@"databaseId"];
//[stepObject saveInBackground];
//
//PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
//textBlockObject[@"title"] = @"AFIB Anticoagulation Title";
//textBlockObject[@"content"] = @"some content";
//textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
//textBlockObject[@"stepDatabaseId"] = stepObject[@"databaseId"];
//textBlockObject[@"databaseId"] = [NSNumber numberWithInt:0];
//[textBlockObject saveInBackground];
//
//PFObject *calculatorComponent = [PFObject objectWithClassName:@"Calculator"];
//calculatorComponent[@"stepDatabaseId"] = stepObject[@"databaseId"];
//calculatorComponent[@"databaseId"] = [NSNumber numberWithInt:0];
//[calculatorComponent saveInBackground];
//
//PFObject *formComponent = [PFObject objectWithClassName:@"Form"];
//formComponent[@"stepDatabaseId"] = stepObject[@"databaseId"];
//formComponent[@"databaseId"] = [NSNumber numberWithInt:0];
//[formComponent saveInBackground];
//
//PFObject *formNumberComponent = [PFObject objectWithClassName:@"FormNumber"];
//formNumberComponent[@"label"] = @"Age";
//formNumberComponent[@"defaultValue"] = [NSNumber numberWithInt:0];
//formNumberComponent[@"minValue"] = [NSNumber numberWithInt:0];
//formNumberComponent[@"maxValue"] = [NSNumber numberWithInt:10];
//formNumberComponent[@"formDatabaseId"] = formComponent[@"databaseId"];
//formNumberComponent[@"databaseId"] = [NSNumber numberWithInt:0];
//[formNumberComponent saveInBackground];
//
//PFObject *selectionComponent = [PFObject objectWithClassName:@"FormSelection"];
//selectionComponent[@"label"] = @"Gender";
//selectionComponent[@"choiceA"] = @"M";
//selectionComponent[@"choiceB"] = @"F";
//selectionComponent[@"formDatabaseId"] = formComponent[@"databaseId"];
//selectionComponent[@"databaseId"] = [NSNumber numberWithInt:0];
//[selectionComponent saveInBackground];
//
//PFObject *selectionComponent2 = [PFObject objectWithClassName:@"FormNumber"];
//selectionComponent2[@"label"] = @"EF(%)";
//selectionComponent2[@"defaultValue"] = [NSNumber numberWithInt:0];
//selectionComponent2[@"minValue"] = [NSNumber numberWithInt:0];
//selectionComponent2[@"maxValue"] = [NSNumber numberWithInt:10];
//calculatorComponent[@"formDatabaseId"] = formComponent[@"databaseId"];
//calculatorComponent[@"databaseId"] = [NSNumber numberWithInt:1];
//[selectionComponent2 saveInBackground];
//
//PFObject *selectionComponent3 = [PFObject objectWithClassName:@"FormSelection"];
//selectionComponent3[@"label"] = @"PM";
//selectionComponent3[@"choiceA"] = @"Y";
//selectionComponent3[@"choiceB"] = @"N";
//selectionComponent3[@"stepDatabaseId"] = formComponent[@"databaseId"];
//selectionComponent3[@"databaseId"] = [NSNumber numberWithInt:1];
//[selectionComponent3 saveInBackground];
//
//PFObject *linkObject = [PFObject objectWithClassName:@"Link"];
//linkObject[@"label"] = @"Calculator link";
//linkObject[@"URL"] = @"http://www.mdcalc.com/chads2-score-for-atrial-fibrillation-stroke-risk/";
//linkObject[@"stepDatabaseId"] = stepObject[@"databaseId"];
//linkObject[@"databaseId"] = [NSNumber numberWithInt:0];
//[linkObject saveInBackground];

