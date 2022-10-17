import XCTest

import Metal

final class MetalCompilerPluginTests: XCTestCase {
    func testExample() throws {
        let shadersBundleURL = Bundle(for: MetalCompilerPluginTests.self).resourceURL!.appending(path: "MetalCompilerPlugin_ExampleShaders.bundle")
        let bundle = Bundle(url: shadersBundleURL)!
        let libraryURL = bundle.url(forResource: "debug", withExtension: "metallib")!
        let device = MTLCreateSystemDefaultDevice()!
        let library = try device.makeLibrary(URL: libraryURL)
        print(library)
    }
}