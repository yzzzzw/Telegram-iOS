load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "WGRequests",
    module_name = "WGRequests",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    deps = [
        "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit"
    ],
    visibility = [
        "//visibility:public",
    ],
)
