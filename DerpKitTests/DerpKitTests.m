//
//  DerpKitTests.m
//  DerpKitTests
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Steve Streza
//  
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "DerpKitTests.h"
#import "Foundation.h"

@implementation DerpKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testBase64WithStart:(NSString *)start end:(NSString *)end{
	STAssertEqualObjects(end,   [start derp_stringByBase64EncodingString], @"base64 encoder is producing invalid results");
	STAssertEqualObjects(start, [end   derp_stringByBase64DecodingString], @"base64 decoder is producing invalid results");
}

- (void)testBase64
{
	[self testBase64WithStart:@"Twilight Sparkle is best pony" end:@"VHdpbGlnaHQgU3BhcmtsZSBpcyBiZXN0IHBvbnk="];
}

-(void)testUTF8{
	NSString *source = @"Twilight Sparkle is best pony";
	NSData *utf8Data = [source derp_UTF8Data];
	NSString *utf8Source = [utf8Data derp_UTF8String];

	STAssertEqualObjects(source, utf8Source, @"UTF8 generates differing data");
}

-(void)testPercentEscaping{
	NSString *original = @"https://developer.apple.com/devcenter/ios/index.action";
	NSString *encoded  = @"https%3A%2F%2Fdeveloper.apple.com%2Fdevcenter%2Fios%2Findex.action";
	
	STAssertEqualObjects([original derp_stringByEscapingPercents], encoded,  @"Percent escaping not working");
	STAssertEqualObjects(original, [encoded derp_stringByUnscapingPercents], @"Percent unescaping not working");
}

-(void)testArrayMapping{
	NSArray *values = [@[ @1, @3, @42, @373 ] derp_arrayByMappingWithHandler:^id(id object, NSUInteger index, BOOL *stop) {
		int number = [object intValue];
		return @(number * 3);
	}];
	
	STAssertTrue(values.count == 4, @"Mapping does not have correct number of values: %i", values.count);
	
	STAssertEqualObjects(values[0], @3,    @"Mapping[0] did not produce valid result - %@ != %@", values[0], @3);
	STAssertEqualObjects(values[1], @9,    @"Mapping[1] did not produce valid result - %@ != %@", values[1], @9);
	STAssertEqualObjects(values[2], @126,  @"Mapping[2] did not produce valid result - %@ != %@", values[2], @126);
	STAssertEqualObjects(values[3], @1119, @"Mapping[3] did not produce valid result - %@ != %@", values[3], @1119);
}

-(void)testArrayFiltering{
	NSArray *values = [@[@1, @2, @3, @4, @5, @6] derp_subarrayByFilteringWithHandler:^BOOL(id object, NSUInteger index, BOOL *stop) {
		return ([object intValue] % 2 == 0);
	}];
	
	STAssertTrue(values.count == 3, @"Filtering does not have correct number of values");
	
	STAssertEqualObjects(values[0], @2,    @"Filtering[0] did not produce valid result - %@ != %@", values[0], @2);
	STAssertEqualObjects(values[1], @4,    @"Filtering[1] did not produce valid result - %@ != %@", values[1], @4);
	STAssertEqualObjects(values[2], @6,    @"Filtering[2] did not produce valid result - %@ != %@", values[2], @6);
}

-(void)testDictionaryMapping{
	NSDictionary *values = [@{ @"foo": @1, @"bar": @14, @"baz": @42}  derp_dictionaryByMappingWithHandler:^id(id object, id key, BOOL *stop) {
		return [NSNumber numberWithInt:([object intValue] * 3)];
	}];
	
	STAssertTrue(values.count == 3, @"Mapping does not have correct number of values: %i", values.count);
	
	STAssertEqualObjects(values[@"foo"], @3,    @"Mapping[foo] did not produce valid result - %@ != %@", values[@"foo"], @3);
	STAssertEqualObjects(values[@"bar"], @42,    @"Mapping[bar] did not produce valid result - %@ != %@", values[@"bar"], @42);
	STAssertEqualObjects(values[@"baz"], @126,  @"Mapping[baz] did not produce valid result - %@ != %@", values[@"baz"], @126);
}

-(void)testDictionaryFiltering{
	NSDictionary *values = [@{ @"foo": @1, @"bar": @14, @"baz": @42}  derp_subdictionaryByFilteringWithHandler:^BOOL(id object, id key, BOOL *stop) {
		return ([object intValue] % 2 == 0);
	}];
	
	STAssertTrue(values.count == 2, @"Filtering does not have correct number of values");
	
	STAssertNil(values[@"foo"], @"Filtering[foo] is not nil");
	STAssertEqualObjects(values[@"bar"], @14,    @"Filtering[bar] did not produce valid result - %@ != %@", values[@"bar"], @14);
	STAssertEqualObjects(values[@"baz"], @42,    @"Filtering[baz] did not produce valid result - %@ != %@", values[@"baz"], @42);
}

@end
