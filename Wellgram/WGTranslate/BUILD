load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "WGTranslate",
    module_name = "WGTranslate",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    deps = [
        "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit",
        "//Wellgram/WGData:WGData"
    ],
    visibility = [
        "//visibility:public",
    ],
)
