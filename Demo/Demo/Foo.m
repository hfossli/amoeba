//
//  Foo.m
//  Demo
//
//  Created by Maria Fossli on 21.11.2016.
//  Copyright © 2016 Acme. All rights reserved.
//

#import "Foo.h"
#import "Demo-Swift.h"

@implementation Foo

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        ViewController *controller = [ViewController new];
        controller.asdf = @"hei";
        
    }
    return self;
}

@end
