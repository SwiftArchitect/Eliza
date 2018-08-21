//    @file:    ChatBot.m
//    @project: Eliza
//
//    Copyright © 2014, 2018 Xavier Schott
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

#import "ChatBot.h"
#import "Eliza.h"

@interface ChatBot ()
@property (nonatomic, strong) Eliza * elisa;
@property (nonatomic, assign) BOOL conversationStarted;

@property (nonatomic, strong) NSString * greeting;

@end

@implementation ChatBot

- (instancetype)init
{
    if (self = [super init]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"BBSCHAT"
                                                         ofType:@"txt"];
        NSAssert(nil != path, @"path?");

        self.elisa = [[Eliza alloc] init];
        [self.elisa read_script:path];
    }
    return self;
}


#pragma mark --

- (NSString *)talk:(NSString *)text
{
    if(self.conversationStarted) {
        return [self.elisa chat_with_eliza:text];
    } else {
        self.conversationStarted = YES;
        return  [self.elisa greet_eliza];
    }
}


@end
