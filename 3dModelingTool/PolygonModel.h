#import <Cocoa/Cocoa.h>

// PolygonModel is a wrapper/proxy for OpenGL polygon modes GL_FILL and GL_LINE.
// Because PolygonModel responds to description, it is suitable for use with
// certain user-interface controls. An alternative design would have been to
// use NSValueTransformer.

@interface PolygonModel : NSObject 
{
    GLenum _value;
    NSString* _description;
}

+ (id) createFill;
+ (id) createLine;

+ (id) createValue: (GLenum) value description: (NSString*) description;

- (id) initValue: (GLenum) value description: (NSString*) description;

- (GLenum) value;
- (NSString*) description;


@end
