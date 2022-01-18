load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "WGData",
    module_name = "WGData",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    deps = [
        "//Wellgram/WGRequests:WGRequests"
    ],
    visibility = [
        "//visibility:public",
    ],
)
