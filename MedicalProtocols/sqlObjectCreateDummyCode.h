//
//  sqlDBObjectCreateDummyCode.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/4/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

//MY TESTING (IN PROTOCOL DATA CONTROLLER)
/*
LocalDB *lb = [LocalDB sharedInstance];
MedProtocol *mp = [[MedProtocol alloc]init];
mp.name = @"High Blood Pressure";
mp.objectId = @"ldsjgbljgr";
NSDate *now = [[NSDate alloc]init];
NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
mp.updatedAt = [calendar dateFromComponents:components];
[lb deleteObjectWithDataType:DataTypeProtocol withId:mp.objectId];
[lb insertObjectWithDataType:DataTypeProtocol withObject:mp];
MedProtocol *newP = [[MedProtocol alloc]init];
newP.objectId = @"ofovep9898";
newP.name = @"High Blood Pressure";
NSDate *newnow = [[NSDate alloc]init];
NSCalendar *newcalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
NSDateComponents *newcomponents = [newcalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newnow];
newP.updatedAt = [newcalendar dateFromComponents:newcomponents];
[lb updateObjectWithDataType:DataTypeProtocol withId:mp.objectId withObject:newP];
*/