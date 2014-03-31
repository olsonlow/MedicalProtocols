//
//  FormNumber.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@interface FormNumber : NSObject
@property(nonatomic,copy) NSString* label;
@property(nonatomic,strong) NSNumber* defaultValue;
@property(nonatomic,strong) NSNumber* maxValue;
@property(nonatomic,strong) NSNumber* minValue;

-(id)initWithParseObject:(PFObject*)parseObject;

@end
