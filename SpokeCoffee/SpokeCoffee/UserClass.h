//
//  UserClass.h
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserClass : NSObject {
    
}

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,retain)NSString *token;

+(UserClass*)getInstance;


@end
