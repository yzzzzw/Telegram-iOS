load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "WGStrings",
    module_name = "WGStrings",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    deps = [
        "//submodules/AppBundle:AppBundle",
        "//Wellgram/WGData:WGData"
    ],
    visibility = [
        "//visibility:public",
    ],
)
