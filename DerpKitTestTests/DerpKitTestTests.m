//
//  DerpKitTestTests.m
//  DerpKitTestTests
//
//  Created by Steve Streza on 28.1.14.
//  Copyright (c) 2014 Mustacheware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Foundation.h"

@interface DerpKitTestTests : XCTestCase

@end

@implementation DerpKitTestTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testBase64WithStart:(NSString *)start end:(NSString *)end{
	XCTAssertEqualObjects(end,   [start derp_stringByBase64EncodingString], @"base64 encoder is producing invalid results");
	XCTAssertEqualObjects(start, [end   derp_stringByBase64DecodingString], @"base64 decoder is producing invalid results");
}

- (void)testBase64
{
	[self testBase64WithStart:@"Twilight Sparkle is best pony" end:@"VHdpbGlnaHQgU3BhcmtsZSBpcyBiZXN0IHBvbnk="];
	[self testBase64WithStart:@"Now, careful, Derpy. You don't wanna do any more damage than you've already done." end:@"Tm93LCBjYXJlZnVsLCBEZXJweS4gWW91IGRvbid0IHdhbm5hIGRvIGFueSBtb3JlIGRhbWFnZSB0aGFuIHlvdSd2ZSBhbHJlYWR5IGRvbmUu"];
	[self testBase64WithStart:@"I just don't know what went wrong!" end:@"SSBqdXN0IGRvbid0IGtub3cgd2hhdCB3ZW50IHdyb25nIQ=="];
}

-(void)testUTF8{
	NSString *source = @"Twilight Sparkle is best pony";
	NSData *utf8Data = [source derp_UTF8Data];
	NSString *utf8Source = [utf8Data derp_UTF8String];
	
	XCTAssertEqualObjects(source, utf8Source, @"UTF8 generates differing data");
}

-(void)testPercentEscaping{
	NSString *original = @"https://developer.apple.com/devcenter/ios/index.action";
	NSString *encoded  = @"https%3A%2F%2Fdeveloper.apple.com%2Fdevcenter%2Fios%2Findex.action";
	
	XCTAssertEqualObjects([original derp_stringByEscapingPercents], encoded,  @"Percent escaping not working");
	XCTAssertEqualObjects(original, [encoded derp_stringByUnscapingPercents], @"Percent unescaping not working");
}

-(void)testArrayMapping{
	NSArray *values = [@[ @1, @3, @42, @373 ] derp_arrayByMappingWithHandler:^id(id object, NSUInteger index, BOOL *stop) {
		int number = [object intValue];
		return @(number * 3);
	}];
	
	XCTAssertTrue(values.count == 4, @"Mapping does not have correct number of values: %i", values.count);
	
	XCTAssertEqualObjects(values[0], @3,    @"Mapping[0] did not produce valid result - %@ != %@", values[0], @3);
	XCTAssertEqualObjects(values[1], @9,    @"Mapping[1] did not produce valid result - %@ != %@", values[1], @9);
	XCTAssertEqualObjects(values[2], @126,  @"Mapping[2] did not produce valid result - %@ != %@", values[2], @126);
	XCTAssertEqualObjects(values[3], @1119, @"Mapping[3] did not produce valid result - %@ != %@", values[3], @1119);
}

-(void)testArrayFiltering{
	NSArray *values = [@[@1, @2, @3, @4, @5, @6] derp_subarrayByFilteringWithHandler:^BOOL(id object, NSUInteger index, BOOL *stop) {
		return ([object intValue] % 2 == 0);
	}];
	
	XCTAssertTrue(values.count == 3, @"Filtering does not have correct number of values");
	
	XCTAssertEqualObjects(values[0], @2,    @"Filtering[0] did not produce valid result - %@ != %@", values[0], @2);
	XCTAssertEqualObjects(values[1], @4,    @"Filtering[1] did not produce valid result - %@ != %@", values[1], @4);
	XCTAssertEqualObjects(values[2], @6,    @"Filtering[2] did not produce valid result - %@ != %@", values[2], @6);
}

-(void)testDictionaryMapping{
	NSDictionary *values = [@{ @"foo": @1, @"bar": @14, @"baz": @42}  derp_dictionaryByMappingWithHandler:^id(id object, id key, BOOL *stop) {
		return [NSNumber numberWithInt:([object intValue] * 3)];
	}];
	
	XCTAssertTrue(values.count == 3, @"Mapping does not have correct number of values: %i", values.count);
	
	XCTAssertEqualObjects(values[@"foo"], @3,    @"Mapping[foo] did not produce valid result - %@ != %@", values[@"foo"], @3);
	XCTAssertEqualObjects(values[@"bar"], @42,    @"Mapping[bar] did not produce valid result - %@ != %@", values[@"bar"], @42);
	XCTAssertEqualObjects(values[@"baz"], @126,  @"Mapping[baz] did not produce valid result - %@ != %@", values[@"baz"], @126);
}

-(void)testDictionaryFiltering{
	NSDictionary *values = [@{ @"foo": @1, @"bar": @14, @"baz": @42}  derp_subdictionaryByFilteringWithHandler:^BOOL(id object, id key, BOOL *stop) {
		return ([object intValue] % 2 == 0);
	}];
	
	XCTAssertTrue(values.count == 2, @"Filtering does not have correct number of values");
	
	XCTAssertNil(values[@"foo"], @"Filtering[foo] is not nil");
	XCTAssertEqualObjects(values[@"bar"], @14,    @"Filtering[bar] did not produce valid result - %@ != %@", values[@"bar"], @14);
	XCTAssertEqualObjects(values[@"baz"], @42,    @"Filtering[baz] did not produce valid result - %@ != %@", values[@"baz"], @42);
}

@end
