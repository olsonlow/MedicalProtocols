    //TODO update parse backend by re-running below code

    PFObject *protocol = [PFObject objectWithClassName:@"Protocol"];
    protocol[@"name"] = @"Atrial Fibrillation";
    protocol[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [protocol saveInBackground];

    //        PFObject *component= [PFObject objectWithClassName:@"Component"];
    //        component[@"color"] = @"0, 214, 132";

    //All objects below are associated with Anticoagulation step.
    PFObject *stepObject = [PFObject objectWithClassName:@"Step"];
    stepObject[@"stepNumber"] = [NSNumber numberWithInt:1];
    stepObject[@"description"] = @"Anticoagulation:";
    stepObject[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    stepObject[@"parentUUID"] = protocol[@"UUID"];
    [stepObject saveInBackground];

    PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
    textBlockObject[@"title"] = @"AFIB";
    textBlockObject[@"content"] = @"Anticoagulation";
    textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
    textBlockObject[@"parentUUID"] = stepObject[@"UUID"];
    textBlockObject[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [textBlockObject saveInBackground];

    PFObject *calculatorComponent = [PFObject objectWithClassName:@"Calculator"];
    calculatorComponent[@"parentUUID"] = stepObject[@"UUID"];
    calculatorComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [calculatorComponent saveInBackground];

    PFObject *formComponent = [PFObject objectWithClassName:@"Form"];
    formComponent[@"parentUUID"] = stepObject[@"UUID"];
    formComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [formComponent saveInBackground];

    PFObject *formNumberComponent = [PFObject objectWithClassName:@"FormNumber"];
    formNumberComponent[@"label"] = @"Age";
    formNumberComponent[@"defaultValue"] = [NSNumber numberWithInt:0];
    formNumberComponent[@"minValue"] = [NSNumber numberWithInt:0];
    formNumberComponent[@"maxValue"] = [NSNumber numberWithInt:110];
    formNumberComponent[@"parentUUID"] = formComponent[@"UUID"];
    formNumberComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [formNumberComponent saveInBackground];

    PFObject *formNumberComponent2 = [PFObject objectWithClassName:@"FormNumber"];
    formNumberComponent2[@"label"] = @"EF(%)";
    formNumberComponent2[@"defaultValue"] = [NSNumber numberWithInt:0];
    formNumberComponent2[@"minValue"] = [NSNumber numberWithInt:0];
    formNumberComponent2[@"maxValue"] = [NSNumber numberWithInt:110];
    formNumberComponent2[@"parentUUID"] = formComponent[@"UUID"];
    formNumberComponent2[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [formNumberComponent2 saveInBackground];

    PFObject *selectionComponent = [PFObject objectWithClassName:@"FormSelection"];
    selectionComponent[@"label"] = @"Gender";
    selectionComponent[@"choiceA"] = @"M";
    selectionComponent[@"choiceB"] = @"F";
    selectionComponent[@"parentUUID"] = formComponent[@"UUID"];
    selectionComponent[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [selectionComponent saveInBackground];

    PFObject *selectionComponent2 = [PFObject objectWithClassName:@"FormSelection"];
    selectionComponent2[@"label"] = @"PM";
    selectionComponent2[@"choiceA"] = @"Y";
    selectionComponent2[@"choiceB"] = @"N";
    selectionComponent2[@"parentUUID"] = formComponent[@"UUID"];
    selectionComponent2[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [selectionComponent2 saveInBackground];

    PFObject *selectionComponent3 = [PFObject objectWithClassName:@"FormSelection"];
    selectionComponent3[@"label"] = @"HTN";
    selectionComponent3[@"choiceA"] = @"Y";
    selectionComponent3[@"choiceB"] = @"N";
    selectionComponent3[@"parentUUID"] = formComponent[@"UUID"];
    selectionComponent3[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [selectionComponent3 saveInBackground];

    PFObject *selectionComponent4 = [PFObject objectWithClassName:@"FormSelection"];
    selectionComponent4[@"label"] = @"CVA";
    selectionComponent4[@"choiceA"] = @"Y";
    selectionComponent4[@"choiceB"] = @"N";
    selectionComponent4[@"parentUUID"] = formComponent[@"UUID"];
    selectionComponent4[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [selectionComponent4 saveInBackground];

    PFObject *linkObject = [PFObject objectWithClassName:@"Link"];
    linkObject[@"label"] = @"Calculator link";
    linkObject[@"url"] = @"http://www.mdcalc.com/chads2-score-for-atrial-fibrillation-stroke-risk/";
    linkObject[@"parentUUID"] = stepObject[@"UUID"];
    linkObject[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [linkObject saveInBackground];

    //All objects below are associated with the Rate Control Med step.
    PFObject *stepObject2 = [PFObject objectWithClassName:@"Step"];
    stepObject2[@"stepNumber"] = [NSNumber numberWithInt:1];
    stepObject2[@"description"] = @"Rate Control Med.:";
    stepObject2[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    stepObject2[@"parentUUID"] = protocol[@"UUID"];
    [stepObject2 saveInBackground];

    PFObject *textBlockObject2 = [PFObject objectWithClassName:@"TextBlock"];
    textBlockObject2[@"title"] = @"AFIB";
    textBlockObject2[@"content"] = @"Afib Rate Control";
    textBlockObject2[@"printable"] = [NSNumber numberWithBool:NO];
    textBlockObject2[@"parentUUID"] = stepObject2[@"UUID"];
    textBlockObject2[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [textBlockObject2 saveInBackground];

    PFObject *formComponent2 = [PFObject objectWithClassName:@"Form"];
    formComponent2[@"parentUUID"] = stepObject2[@"UUID"];
    formComponent2[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [formComponent2 saveInBackground];

    PFObject *textBlockObject3 = [PFObject objectWithClassName:@"TextBlock"];
    textBlockObject3[@"title"] = @"Atenol";
    textBlockObject3[@"content"] = @"25 Mgb:d";
    textBlockObject3[@"printable"] = [NSNumber numberWithBool:YES];
    textBlockObject3[@"parentUUID"] = stepObject2[@"UUID"];
    textBlockObject3[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [textBlockObject3 saveInBackground];

    PFObject *textBlockObject4 = [PFObject objectWithClassName:@"TextBlock"];
    textBlockObject4[@"title"] = @"Atenol";
    textBlockObject4[@"content"] = @"50 Mgb:d";
    textBlockObject4[@"printable"] = [NSNumber numberWithBool:NO];
    textBlockObject4[@"parentUUID"] = stepObject2[@"UUID"];
    textBlockObject4[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [textBlockObject4 saveInBackground];

    PFObject *selectionComponent5 = [PFObject objectWithClassName:@"FormSelection"];
    selectionComponent5[@"label"] = @"Resting Heart Rate";
    selectionComponent5[@"choiceA"] = @"<90 - 100";
    selectionComponent5[@"choiceB"] = @">100";
    selectionComponent5[@"parentUUID"] = formComponent2[@"UUID"];
    selectionComponent5[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [selectionComponent5 saveInBackground];


    //All objects below are associated with Rate vs Rhythm step.
    PFObject *stepObject3 = [PFObject objectWithClassName:@"Step"];
    stepObject3[@"stepNumber"] = [NSNumber numberWithInt:1];
    stepObject3[@"description"] = @"Rate vs Rhythm:";
    stepObject3[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    stepObject3[@"parentUUID"] = protocol[@"UUID"];
    [stepObject3 saveInBackground];

    PFObject *textBlockObject5 = [PFObject objectWithClassName:@"TextBlock"];
    textBlockObject5[@"title"] = @"Rate vs Rhythm";
    textBlockObject5[@"content"] = @"This will help decide whether to controll heart rate or controll rhythm.";
    textBlockObject5[@"printable"] = [NSNumber numberWithBool:NO];
    textBlockObject5[@"parentUUID"] = stepObject3[@"UUID"];
    textBlockObject5[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [textBlockObject5 saveInBackground];

    //This may or may not need to be a calculator, this object is where the
    //dial like knob would go in Jitesh's drawing.
    PFObject *calculatorComponent2 = [PFObject objectWithClassName:@"Calculator"];
    calculatorComponent2[@"parentUUID"] = stepObject3[@"UUID"];
    calculatorComponent2[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [calculatorComponent2 saveInBackground];

    PFObject *stepObject4 = [PFObject objectWithClassName:@"Step"];
    stepObject4[@"stepNumber"] = [NSNumber numberWithInt:1];
    stepObject4[@"description"] = @"When to Report:";
    stepObject4[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    stepObject4[@"parentUUID"] = protocol[@"UUID"];
    [stepObject4 saveInBackground];

    PFObject *textBlockObject6 = [PFObject objectWithClassName:@"TextBlock"];
    textBlockObject6[@"title"] = @"Referring to Cardiology";
    textBlockObject6[@"content"] = @"Refer to cardiology based on output of calculator above.";
    textBlockObject6[@"printable"] = [NSNumber numberWithBool:YES];
    textBlockObject6[@"parentUUID"] = stepObject4[@"UUID"];
    textBlockObject6[@"UUID"] = [[[NSUUID alloc] init] UUIDString];
    [textBlockObject6 saveInBackground];

