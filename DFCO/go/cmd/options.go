package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/go-flutter-desktop/plugins/url_launcher"
	sqflite "github.com/nealwon/go-flutter-plugin-sqlite"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(510, 850),
	flutter.WindowDimensionLimits(510, 850, 610, 850),
	flutter.ForcePixelRatio(1.5),
	flutter.AddPlugin(sqflite.NewSqflitePlugin("edialog-otr", "dfco")),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "edialog-otr",
		ApplicationName: "dfco",
	}),
	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
}
