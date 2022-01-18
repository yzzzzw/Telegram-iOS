load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "WGWebUtils",
    module_name = "WGWebUtils",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    deps = [
        "//Wellgram/WGData:WGData",
        "//submodules/Postbox:Postbox",
        "//submodules/TelegramCore:TelegramCore"
    ],
    visibility = [
        "//visibility:public",
    ],
)
