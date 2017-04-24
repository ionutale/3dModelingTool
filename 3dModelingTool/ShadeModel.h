#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

// ShadeModel is a wrapper/proxy for OpenGL shade models GL_FLAT and GL_SMOOTH.
// Because ShadeModel responds to description, it is suitable for use with
// certain user-interface controls. An alternative design would have been to
// use NSValueTransformer.

@interface ShadeModel : NSObject {

    GLenum _value;
    NSString* _description;
    
}

+ (id) createFlat;
+ (id) createSmooth;

+ (id) createValue: (GLenum) value description: (NSString*) description;

- (id) initValue: (GLenum) value description: (NSString*) description;

- (GLenum) value;
- (NSString*) description;

@end
