#import "AoepubViewerPlugin.h"
#if __has_include(<aoepub_viewer/aoepub_viewer-Swift.h>)
#import <aoepub_viewer/aoepub_viewer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aoepub_viewer-Swift.h"
#endif

@implementation AoepubViewerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAoepubViewerPlugin registerWithRegistrar:registrar];
}
@end
