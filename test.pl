use Test;
BEGIN { plan tests => 19 };
use Tie::Log;

ok(1);

my $logfile = 'test.log';
unlink($logfile);

ok(tie *LOG, 'Tie::Log', $logfile);
ok(print LOG "Test begun\n");
ok(printf LOG "%s", "testing still");
ok(close(LOG));

if (open(CHK, $logfile)) {
	ok(1);
	my $first  = <CHK>;
	my $second = <CHK>;
	ok($first,  qr/Test begun/);
	ok($second, qr/testing still/);
	close(CHK);
} else {
	ok(0); ok(0); ok(0);
} 

unlink($logfile);


ok(tie *LOG2, 'Tie::Log', $logfile, 'format' => '"%m" -- %d -- %p');
ok(print LOG2 "Funky Format");
ok(close(LOG2));

if (open(CHK, $logfile)) {
	ok(1);
	my $line = <CHK>;
	ok($line, qr/^"F/);
	close(CHK);
} else {
	ok(0); ok(0);
}
unlink($logfile);



ok(tie *LOG3, 'Tie::Log', $logfile, 'tformat' => '%X %x');
ok(print LOG3 "Time Format!");
ok(close(LOG3));

if (open(CHK, $logfile)) {
	ok(1);
	my $line = <CHK>;
	ok($line, qr/Time/);
	close(CHK);
} else {
	ok(0); ok(0);
}
unlink($logfile);
 