//
//  DerpKitTests.m
//  DerpKitTests
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
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

-(void)testMapping{
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

-(void)testFiltering{
	NSArray *values = [@[@1, @2, @3, @4, @5, @6] derp_subarrayByFilteringWithHandler:^BOOL(id object, NSUInteger index, BOOL *stop) {
		return ([object intValue] % 2 == 0);
	}];
	
	STAssertTrue(values.count == 3, @"Filtering does not have correct number of values");
	
	STAssertEqualObjects(values[0], @2,    @"Filtering[0] did not produce valid result - %@ != %@", values[0], @2);
	STAssertEqualObjects(values[1], @4,    @"Filtering[1] did not produce valid result - %@ != %@", values[1], @4);
	STAssertEqualObjects(values[2], @6,    @"Filtering[2] did not produce valid result - %@ != %@", values[2], @6);
}

@end
