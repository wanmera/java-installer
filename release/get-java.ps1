# Java Installer for OpenJDK 17.0.1


param (
	[string]$command = 'get',
	[string]$type = 'jdk',
	[string]$arch = 'x86_64',
	[string]$os = 'Windows',
	[string]$out
)


$ErrorActionPreference = "Stop"


Switch ("$os $arch $type") {
	"Linux x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "1c0a73cbb863aad579b967316bf17673b8f98a9bb938602a140ba2e5c38f880a"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-linux-i586.tar.gz"
		$JDK_SHA256 = "7dda1aac55e66e962d32c1a4661360b05c891645197f785f2052fafc9a0d350b"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-aarch64_bin.tar.gz"
		$JDK_SHA256 = "86653d48787e5a1c029df10da7808194fe8bd931ddd72ff3d42850bf1afb317e"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "cfc1b58dd4c768d601ee34bd88f5bc20a5877204d02f524dcc3766c305b0a0ac"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "146036fcfdedaeb63f1624987e26ba59c8b70d9f2015d01c775345a6c8beef72"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_macos-x64_bin.tar.gz"
		$JDK_SHA256 = "6ccb35800e723cabe15af60e67099d1a07c111d2d3208aa75523614dde68bee1"
	}
	"Darwin aarch64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_macos-aarch64_bin.tar.gz"
		$JDK_SHA256 = "45acad5647960ecde83dc1fb6dda72e5e274798660fa9acff0fb9cc8a37b5794"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "329900a6673b237b502bdcf77bc334da34bc91355c5fd2d457fc00f53fd71ef1"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-windows-i586.zip"
		$JDK_SHA256 = "33891b03583bc8a0b304e4dd0cde4136069b0605a2612d4dfdb7d15e24a1e5c7"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "28662b6fcdaedaaf23ee6dbef2d632bf2a53e30aaa9231f27e00e6ceb10238a0"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "40525cc333f48acbc62657f5cfbc30635940c4bc61d42f6a1e19ab3e208b2744"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "836f8c88235d2f38b0922b4b2949e35071e9e0a7c1d22a0bebc67b476885b56b"
	}
	"Darwin aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "90c922bdf87686b81deadbffd5c75186f92851852df333b870bf61e98e04c190"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "a9b8dbd6b67081470d7b4204af2b7ffb6130c07daf1e2967eec7c9342f6d2caf"
	}

	default {
		throw "CPU architecture not supported."
	}
}


# fetch JDK
if ($out) {
	$JDK_TAR_GZ = $out
} else {
	$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL	
}


if (!(test-path $JDK_TAR_GZ)) {
	Write-Output "Download $JDK_URL"
	(New-Object System.Net.WebClient).DownloadFile($JDK_URL, $JDK_TAR_GZ)
}


# verify archive via SHA-256 checksum
$JDK_SHA256_ACTUAL = (Get-FileHash -Algorithm SHA256 $JDK_TAR_GZ).hash.toLower()
Write-Output "Expected SHA256 checksum: $JDK_SHA256"
Write-Output "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if ($JDK_SHA256 -ne $JDK_SHA256_ACTUAL) {
	throw "ERROR: SHA256 checksum mismatch"
}


# extract and link only if explicitly requested
if ($command -ne "install") {
	Write-Output "Download complete: $JDK_TAR_GZ"
	return
}


# extract zip archive
Write-Output "Extract $JDK_TAR_GZ"
Expand-Archive -Path $JDK_TAR_GZ -DestinationPath .


# find java executable
$JAVA_EXE = Get-ChildItem -recurse -include java.exe | Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 1

# test
Write-Output "Execute ""$JAVA_EXE"" -XshowSettings -version"
& $JAVA_EXE -XshowSettings -version


# set %JAVA_HOME% and add java to %PATH%
$JAVA_HOME = Split-Path -Parent (Split-Path -Parent $JAVA_EXE)

Write-Output "`nPlease add JAVA_HOME\bin to the PATH if you have not done so already:"
Write-Output "`n`t%JAVA_HOME%\bin"
Write-Output "`nPlease set JAVA_HOME:"
Write-Output "`n`tsetx JAVA_HOME ""$JAVA_HOME"""
