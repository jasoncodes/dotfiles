function realpath()
{
  perl - "$@" <<PERL
    use Cwd 'abs_path';

    if (-e \$ARGV[0]) {
      print abs_path(\$ARGV[0]) . "\n";
    } else {
      exit 1;
    }
PERL
}
