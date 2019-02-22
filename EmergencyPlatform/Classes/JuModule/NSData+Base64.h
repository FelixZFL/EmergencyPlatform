// http://www.cocoadev.com/index.pl?BaseSixtyFour

@interface NSData (Base64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)shBase64Encoding;

@end
