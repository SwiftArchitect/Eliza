//    @file:    TGPEliza.m
//    @project: TGPEliza
//
//    @history: Created December 25, 2014 (Christmas Day)
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2014, Xavier Schott
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

#import "TGPEliza.h"


//    keyrec = record
//               word : NSString *;
//               resp_set : NSInteger;
//               end
@interface keyrec : NSObject
@property (nonatomic, strong) NSString * word;
@property (nonatomic, assign) NSInteger resp_set;
@end

@implementation keyrec

- (instancetype) init {
    if(self = [super init]) {
        self.word = nil;
        self.resp_set = 0;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"word:%@\n"
            "resp_set:%lu",
            self.word, (unsigned long)self.resp_set];
}

@end

//    reprec = record
//               tot_resp : NSInteger;
//               last_resp : NSInteger;
//               reply : array[0..max_reply] of NSString *;
//             end;
@interface reprec : NSObject
//@property (nonatomic, assign) NSInteger tot_resp;
@property (nonatomic, assign) NSInteger last_resp;
@property (nonatomic, strong) NSMutableArray * reply;
@end

@implementation reprec

- (instancetype)init {
    if(self = [super init]) {
        self.last_resp = NSNotFound;
        self.reply = [NSMutableArray array];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"last_resp:%lu\n"
            "reply:%@",
            (unsigned long)self.last_resp, self.reply];
}

@end

typedef NS_ENUM(unichar, RecType) {
    RECTYPEUNKNOWN = '0',
    SIGNON = 'S',
    TRANSPOSE = 'T',
    NULLRESPONSE = 'N',
    MYRESPONSE = 'M',
    NOKEY= 'X',
    KEYWORD = 'K',
    RESPONSESET = 'R'
};

const NSInteger max_trans = 1024;   // number of words to transpose
const NSInteger max_reply = 1020;   // the maximum number of replies for each set of responses
const NSInteger max_key = 1100;    // maximum number of key words

@interface TGPEliza ()
@property (nonatomic, assign) BOOL case_switch; // tells the input routine on the bbs to
// convert lower case to upper.  serves
// no purpose here, though

@property (nonatomic, assign) NSUInteger line_no;
@property (nonatomic, strong) NSString * tmp_str;
@property (nonatomic, strong) NSArray * text_file; //  text_file : text[4096];
@property (nonatomic, assign) BOOL end_of_chat;
@property (nonatomic, strong) reprec * my_resp;
@property (nonatomic, strong) reprec * no_key;
@property (nonatomic, strong) reprec * null_resp;
@property (nonatomic, strong) reprec * signon;
@property (nonatomic, strong) NSString * this_keyword;
@property (nonatomic, strong) NSString * user_input;
@property (nonatomic, assign) NSInteger current_response;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) NSUInteger key_no;
@property (nonatomic, strong) NSMutableArray * keywords; //key_word_array
@property (nonatomic, assign) BOOL key_found;
@property (nonatomic, assign) NSInteger l;
@property (nonatomic, strong) NSString * my_str;
@property (nonatomic, assign) BOOL null_input;
@property (nonatomic, strong) NSString * prog_output;
@property (nonatomic, assign) NSInteger resp_no;
@property (nonatomic, strong) NSString * response;
@property (nonatomic, strong) NSMutableArray * response_set; // resp_set_array
@property (nonatomic, assign) NSUInteger save_key_no;
@property (nonatomic, strong) NSMutableArray * wordin; // transpose_array;
@property (nonatomic, strong) NSMutableArray * wordout; // transpose_array;
@property (nonatomic, assign) unichar x; // byte
@property (nonatomic, assign) BOOL line_buffered;
@property (nonatomic, assign) RecType rec_type;


@end


@implementation TGPEliza

#pragma mark -- NSObject

- (instancetype)init
{
    if (self = [super init]) {

        //  type
        //    key_word_array = array[1..max_key] of keyrec;
        //    resp_set_array = array[1..max_key] of reprec;
        //    transpose_array = array[1..max_trans] of NSString *;

        self.my_resp = [[reprec alloc] init];
        self.null_resp = [[reprec alloc] init];
        self.no_key = [[reprec alloc] init];

        self.response_set = [NSMutableArray array];

        //    for i := 1 to max_key do
        //      response_set[i].last_resp := -1;

        self.my_str = nil;
        self.end_of_chat = false;
        self.case_switch = false;
        //    writeln('Enter QUIT to quit chatting');
        //    writeln;
    }
    return self;
}

#pragma mark -- program eliza

- (void)check_time_limit {}
- (void)clear_buffer {}

- (NSString *)write_line:(NSString *)tstr {
    // Randomly insert error characters
    //  var
    //    i : NSInteger;
    //
    //    for i := 1 to (tstr.length) do
    //      {
    //        if arc4random_uniform((unsigned int)50) = 0 then
    //          {
    //            write_char(chr(arc4random_uniform((unsigned int)26)+65));
    //            //delay(100 + arc4random_uniform((unsigned int)100));
    //            write_char(#8);
    //          }
    //        write_char(tstr[i]);
    //      }
    //    writeln;
    NSMutableString * lowercaseString = [NSMutableString stringWithString:[tstr lowercaseString]];
    [lowercaseString replaceOccurrencesOfString:@" i'"
                                     withString:@" I'"
                                        options:0
                                          range:NSMakeRange(0, lowercaseString.length)];
    [lowercaseString replaceOccurrencesOfString:@" i "
                                     withString:@" I "
                                        options:0
                                          range:NSMakeRange(0, lowercaseString.length)];
    [lowercaseString replaceOccurrencesOfString:@"i'm "
                                     withString:@"I'm "
                                        options:0
                                          range:NSMakeRange(0, lowercaseString.length)];
    return lowercaseString;
}

- (NSString *)trimTrailingQuote:(NSString*)str {
    //tmp_str[0] := pred(tmp_str[0]);
    NSAssert(str.length > 1, @"str too short");
    if(str.length > 1) {
        const NSUInteger lastPosition = str.length -1;
        const unichar lastCharacter = [str characterAtIndex:lastPosition];
        NSAssert2('"' == lastCharacter,
                  @"Keyword [%@] does not end with a \" but a [%c].",
                  str,
                  lastCharacter);
        return (('"' == lastCharacter)
         ? [str substringToIndex:lastPosition]
                : str);
    }
    return str;
}

- (void)add_transpose {
    if(self.wordin.count < max_trans) {

        [self.wordin addObject:[self trimTrailingQuote:self.tmp_str]];

        [self read_script_line];

        if(TRANSPOSE == self.rec_type) {
            [self.wordout addObject:[self trimTrailingQuote:self.tmp_str]];
        } else {
            self.end_of_chat = true;
        }
    }
}

- (void)add_keyword {
    if(self.keywords.count != max_key) {
        const keyrec * aKey = [[keyrec alloc] init];
        aKey.word = [self trimTrailingQuote:self.tmp_str];
        aKey.resp_set = self.current_response;
        [self.keywords addObject:aKey];
    } else {
        self.end_of_chat = true;
    }
}

- (void)add_response:(reprec *)tmp_resp {
    if(tmp_resp.reply.count <= max_reply) {
        [tmp_resp.reply addObject:self.tmp_str];
    }
    else {
        self.end_of_chat = true;
    }
}

- (void)add_response_set {
    reprec * response = [[reprec alloc] init];

    NSAssert2(self.response_set.count == self.current_response,
              @"response count:%lu != response_set.count(%lu)",
              (unsigned long)self.current_response, (unsigned long)self.response_set.count);

    [self.response_set addObject:response];

    NSAssert2(self.response_set[self.current_response] == response,
              @"Can't find response %@ we just added at index %lu",
              response,
              (unsigned long)self.current_response);

    while(RESPONSESET == self.rec_type) {
        // [self add_response:self.response_set[self.current_response]];
        [self add_response:response];
        [self read_script_line];
    }
    self.current_response += 1;
    self.line_buffered = (self.rec_type != RECTYPEUNKNOWN);
}

- (void)read_script_line {
    do {
        if(self.line_no < self.text_file.count) {
            self.tmp_str = [self.text_file objectAtIndex:self.line_no];
            self.line_no += 1;
            if(self.tmp_str.length < 2) {   // Skip CR, LF, ; and all other single characters lines
                self.tmp_str = @";";
            }
        }
        else {
            self.tmp_str = nil;
        }
    } while([self.tmp_str hasPrefix:@";"]);

    self.rec_type = ((self.tmp_str.length > 0)
                     ? [self.tmp_str characterAtIndex:0]
                     : RECTYPEUNKNOWN);

    // tmp_str[0] := pred(tmp_str[0]);
    self.tmp_str = ((self.tmp_str.length > 1)
                    ? [self.tmp_str substringFromIndex:1]
                    : nil);

}

- (void)read_script:(NSString *)filePath {

    self.line_no = 0;
    self.rec_type = RECTYPEUNKNOWN;

    NSError * ioresult = noErr;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&ioresult];

    if(ioresult != noErr) {
        self.end_of_chat = true;
    } else {
        NSArray * preParsed = [fileContents componentsSeparatedByCharactersInSet:
                               [NSCharacterSet newlineCharacterSet]];

        NSMutableArray * cleanParse = [NSMutableArray array];
        [preParsed enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            if(0 != obj.length) {
                [cleanParse addObject:obj];
            }

        }];
        self.text_file = cleanParse;

        self.keywords = [NSMutableArray array];
        self.wordin = [NSMutableArray array];
        self.wordout = [NSMutableArray array];
        self.current_response = 0;

        self.my_resp = [[reprec alloc] init];
        self.null_resp = [[reprec alloc] init];
        self.no_key = [[reprec alloc] init];
        self.signon = [[reprec alloc] init];

        self.line_buffered = false;

        while((self.line_no < self.text_file.count) && (!self.end_of_chat)) {
            if(!self.line_buffered) {
                [self read_script_line];
            }
            self.line_buffered = false;
            switch (self.rec_type) {
                case SIGNON:
                    [self add_response:self.signon];
                    break;
                case TRANSPOSE:
                    [self add_transpose];
                    break;
                case NULLRESPONSE:
                    [self add_response:self.null_resp];
                    break;
                case MYRESPONSE:
                    [self add_response:self.my_resp];
                    break;
                case NOKEY:
                    [self add_response:self.no_key];
                    break;
                case KEYWORD:
                    [self add_keyword];
                    break;
                case RESPONSESET:
                    [self add_response_set];
                    break;

                default:
                    self.end_of_chat = true;
                    break;
            }
        }
    }

    if(self.end_of_chat) {
        NSLog(@"Script file error, line %lu", (unsigned long)self.line_no);
    }
}

- (NSString *)get_response:(NSString *)input {
    [self check_time_limit];
    [self clear_buffer];

    NSString * letterCharacterOnly = [[input componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]
                                                                                   invertedSet]]
                                      componentsJoinedByString:@" "];
    NSString * uppercased = [letterCharacterOnly uppercaseString];
    NSString * trimmedString = [uppercased stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
    self.null_input = (trimmedString.length < 1);
    self.user_input = ((self.null_input)
                       ? @"" 
                       : [NSString stringWithFormat:@" %@ ", trimmedString]);

    if([trimmedString isEqualToString:@"QUIT"]) {
        self.end_of_chat = true;
        return [self write_line:@"NICE TALKING TO YOU..."];
    }
    return @"";
}

- (void)find_keyword {
    self.key_found = false;
    self.this_keyword = nil;
    self.prog_output = nil;
    self.key_no = NSNotFound;

    // Look into the entire string (no prioritization)
    NSRange sentence = NSMakeRange(0, self.user_input.length);

    [self.keywords enumerateObjectsUsingBlock:^(keyrec * keyword, NSUInteger idx, BOOL *stop) {
        NSRange keywordRange = [self.user_input rangeOfString:keyword.word
                                                      options:0
                                                        range:sentence];
        if(NSNotFound != keywordRange.location) {
            self.this_keyword = keyword.word;
            self.key_found = YES;
            self.key_no = idx;

            self.prog_output = [NSString stringWithFormat:@" %@ ",
                                [self.user_input substringFromIndex:keywordRange.location + keywordRange.length]];
            *stop = YES;
        }
    }];
}

- (void)conjugate_and_transpose {
    NSMutableString * rawOutput = [NSMutableString stringWithString:self.prog_output];
    NSMutableString * processedOutput = [NSMutableString string];

    while(rawOutput.length > 0) {
        [self.wordin enumerateObjectsUsingBlock:^(NSString * wordIn, NSUInteger idx, BOOL *stop) {
            if([rawOutput hasPrefix:wordIn]) {
                NSString * wordOut = self.wordout[idx];
                [processedOutput appendString:wordOut];
                [rawOutput deleteCharactersInRange:NSMakeRange(0, wordIn.length)];
                *stop = YES;
            }
        }];

        // Advance 1 character
        [processedOutput appendString:[rawOutput substringToIndex:1]];
        [rawOutput deleteCharactersInRange:NSMakeRange(0, 1)];
    }

    self.prog_output = [processedOutput stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    if([self.this_keyword isEqualToString:@"MY"]) {
        self.my_str = self.prog_output;
    }
}

- (NSString *)show_response:(reprec *)rset prog_out:(NSString *)prog_out  {
    self.resp_no = arc4random_uniform((unsigned int)rset.reply.count);

    // pick a different response from last
    if(rset.reply.count > 1) {
        while(self.resp_no == rset.last_resp) {
            self.resp_no = arc4random_uniform((unsigned int)rset.reply.count);
        }
    }

    self.response = rset.reply[self.resp_no];
    rset.last_resp = self.resp_no;
    NSMutableString * tmp_str = [NSMutableString stringWithString:self.response];

    NSRange asterisk = [tmp_str rangeOfString:@"*"];
    NSMutableString * substitution = [NSMutableString stringWithString:prog_out];
    if(asterisk.location != NSNotFound) {
        // Add trailing space if within a sentence
        if(asterisk.location != tmp_str.length-2) {
            [substitution appendString:@" "];
        }
        // Add leading space, always
        [substitution insertString:@" " atIndex:0];
    }
    [tmp_str replaceOccurrencesOfString:@"*"
                             withString:substitution
                                options:NSBackwardsSearch
                                  range:NSMakeRange(0, tmp_str.length)];
    return [self write_line:tmp_str];
}

- (NSString *)show_reply {
    if (! self.key_found) {
        if((self.my_str.length > 0) && (0 == arc4random_uniform(5))) {
            return [self show_response:self.my_resp prog_out:self.my_str];
        } else {
            self.tmp_str = nil;
            if(self.null_input) {
                return [self show_response:self.null_resp prog_out:@""];
            } else {
                return [self show_response:self.no_key prog_out:@""];
            }
        }
    }else {
        const keyrec * keyword = [self.keywords objectAtIndex:self.key_no];
        self.current_response = keyword.resp_set;
        return [self show_response:self.response_set[self.current_response] prog_out:self.prog_output];
    }
}

// @return greeting
- (NSString *)greet_eliza {
    if( !self.end_of_chat) {
        const NSUInteger i = arc4random_uniform((unsigned int)self.signon.reply.count);
        return [self write_line:self.signon.reply[i]];
    }
    return @"";
}

// @return chat message
- (NSString *)chat_with_eliza:(NSString *)message {
    NSString * quitResponse = [self get_response:message];
    if( !self.end_of_chat) {
        [self find_keyword];
        if(self.key_found) {
            [self conjugate_and_transpose];
        }
        return [self show_reply];
    }
    return quitResponse;
}

@end
