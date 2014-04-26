//
//  UserClass.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "UserClass.h"

@implementation UserClass

static UserClass *instance =nil;
+(UserClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [UserClass new];
        }
    }
    return instance;
}

@end
