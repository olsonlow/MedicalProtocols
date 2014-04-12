//////TODO update parse backend by re-running below code
//
//PFObject *protocol = [PFObject objectWithClassName:@"Protocol"];
//protocol[@"name"] = @"Atrial Fibrillation";
//protocol[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[protocol saveInBackground];
//
////        PFObject *component= [PFObject objectWithClassName:@"Component"];
////        component[@"color"] = @"0, 214, 132";
//PFObject *stepObject = [PFObject objectWithClassName:@"Step"];
//stepObject[@"stepNumber"] = [NSNumber numberWithInt:1];
//stepObject[@"description"] = @"Decision Regarding Anticoagulation:";
//stepObject[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//stepObject[@"parentUUID"] = protocol[@"UUID"];
//[stepObject saveInBackground];
//
//PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
//textBlockObject[@"title"] = @"AFIB Anticoagulation Title";
//textBlockObject[@"content"] = @"some content";
//textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
//textBlockObject[@"parentUUID"] = stepObject[@"UUID"];
//textBlockObject[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[textBlockObject saveInBackground];
//
//PFObject *calculatorComponent = [PFObject objectWithClassName:@"Calculator"];
//calculatorComponent[@"parentUUID"] = stepObject[@"UUID"];
//calculatorComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[calculatorComponent saveInBackground];
//
//PFObject *formComponent = [PFObject objectWithClassName:@"Form"];
//formComponent[@"parentUUID"] = stepObject[@"UUID"];
//formComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[formComponent saveInBackground];
//
//PFObject *formNumberComponent = [PFObject objectWithClassName:@"FormNumber"];
//formNumberComponent[@"label"] = @"Age";
//formNumberComponent[@"defaultValue"] = [NSNumber numberWithInt:0];
//formNumberComponent[@"minValue"] = [NSNumber numberWithInt:0];
//formNumberComponent[@"maxValue"] = [NSNumber numberWithInt:10];
//formNumberComponent[@"parentUUID"] = formComponent[@"UUID"];
//formNumberComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[formNumberComponent saveInBackground];
//
//PFObject *selectionComponent = [PFObject objectWithClassName:@"FormSelection"];
//selectionComponent[@"label"] = @"Gender";
//selectionComponent[@"choiceA"] = @"M";
//selectionComponent[@"choiceB"] = @"F";
//selectionComponent[@"parentUUID"] = formComponent[@"UUID"];
//selectionComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[selectionComponent saveInBackground];
//
//PFObject *selectionComponent2 = [PFObject objectWithClassName:@"FormNumber"];
//selectionComponent2[@"label"] = @"EF(%)";
//selectionComponent2[@"defaultValue"] = [NSNumber numberWithInt:0];
//selectionComponent2[@"minValue"] = [NSNumber numberWithInt:0];
//selectionComponent2[@"maxValue"] = [NSNumber numberWithInt:10];
//calculatorComponent[@"parentUUID"] = formComponent[@"UUID"];
//calculatorComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[selectionComponent2 saveInBackground];
//
//PFObject *selectionComponent3 = [PFObject objectWithClassName:@"FormSelection"];
//selectionComponent3[@"label"] = @"PM";
//selectionComponent3[@"choiceA"] = @"Y";
//selectionComponent3[@"choiceB"] = @"N";
//selectionComponent3[@"parentUUID"] = formComponent[@"UUID"];
//selectionComponent3[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[selectionComponent3 saveInBackground];
//
//PFObject *linkObject = [PFObject objectWithClassName:@"Link"];
//linkObject[@"label"] = @"Calculator link";
//linkObject[@"url"] = @"http://www.mdcalc.com/chads2-score-for-atrial-fibrillation-stroke-risk/";
//linkObject[@"parentUUID"] = stepObject[@"UUID"];
//linkObject[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
//[linkObject saveInBackground];
