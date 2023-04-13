# MetalCompilerPlugin

Swift Package Manager plug-in to compile Metal files that can be debugged in Xcode Metal Debugger.

## Description

Swift Package Manager now[^1] seems to compile all Metal files within a target into a `default.metallib`. Alas, this file cannot be debugged in Xcode Metal Debugger.

> Unable to create shader debug session
>
> Source is unavailable
>
> Under the target's Build Settings, ensure the Metal Compiler Build Options produces debugging information and includes source code.
>
> If building with the 'metal' command line tool, include the options '-gline-tables-only' and '-frecord-sources'.

([Screenshot](Documentation/Screenshot%201.png)).

This plug-in provides an alternative way to compile Metal files into a `metallib` that can be debugged.

This project also shows how to create a ["_Pure-Metal target_"](#pure-metal-targets) that can be used to contain your Metal source code and header files.

[^1]: Prior to Swift Package Manager 5.3 it was impossible to process Metal files at all. Version 5.3 added the capability to process resources, including Metal files. Somewhere between versions 5.3 and 5.7 Swift Package Manager gained the ability to transparently compile all Metal files in a package.

## Usage

In your `Package.swift` file, add  `MetalCompilerPlugin` as a dependency. And add the `MetalCompilerPlugin` to your target's `plugins` array.

For example:

```swift
    dependencies: [
        .package(url: "https://github.com/schwa/MetalCompilerPlugin", branch: "main"),
    ],
    targets: [
        .target(name: "MyExampleShaders", plugins: [
            .plugin(name: "MetalCompilerPlugin", package: "MetalCompilerPlugin")
        ]),
    ]
```

Note the title of the output metal library file will be `debug.metallib` and will live side-by-side with the `default.metallib` file. See [Limitations](#limitations) below.

## Limitations

The output metal library file will be `debug.metallib` and will live side-by-side with the `default.metallib` file. This is because of the `default.metallib` file is created by the Swift Package Manager and cannot be overridden.

You will not be able to use `MTLDevice.makeDefaultLibrary()` to load the `debug.metallib` file. Instead, you will need to use `MTLDevice.makeLibrary(url:)` to load the `debug.metallib` file. See the unit tests for an example.

## Pure-Metal Targets

A "Pure-Metal" target is a target that contains only Metal source code and header files. This is useful for projects that contain a lot of Metal code and want to keep it separate from the rest of the project.

This is also useful so that Metal and Swift can share types defined in common header files. For example, a Vertex or Uniforms struct defined in a header file can be used by both Metal and Swift code.

Direct sharing of Metal types with Swift prevents duplication of types and makes sure that your types have a consistent layout and packing across Metal and Swift. Simply defining the same type in both Metal and Swift manually is not enough and can lead to subtle memory alignment-related crashes or data corruption.

See the `ExampleShaders` target in the `Package.swift` file. The "Pure-Metal" target must not contain any Swift files. It should contain your Metal source code and header files (contained in an included folder). It should also contain a `Module.map` file that allows Swift to import the header files.

## License

BSD 3-clause. See [LICENSE.md](LICENSE.md).

## TODO

- [ ] File and link to feedback items for the limitations and issues above.
- [ ] More configuration options.
- [ ] Searching for .metallib works in Xcode Unit Tests but fails under `swift test`. Why?
