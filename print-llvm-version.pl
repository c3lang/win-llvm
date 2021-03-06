use strict;

my $fileName = $ARGV[0] || die("Usage: print-llvm-version.pl <CMakeLists.txt>\n");
open (my $file, "<", $fileName) || die("Can't open $fileName for reading: $!\n");

my %llvmVersion = (
	"MAJOR" => 1,
	"MINOR" => 0,
	"PATCH" => 0,
);

while (my $s = <$file>) {
	if ($s =~ m/set\s*\(\s*LLVM_VERSION_(MAJOR|MINOR|PATCH)\s+([0-9]+)\s*\)/) {
		$llvmVersion{$1} = $2;
	}
}

printf("%d.%d.%d", $llvmVersion{"MAJOR"}, $llvmVersion{"MINOR"}, $llvmVersion{"PATCH"});
