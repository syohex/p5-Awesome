requires 'parent';
requires 'Mouse';

on test => sub {
    requires 'Test::More', '0.98';
};

on configure => sub {
    require 'Parse::Yapp' => '1.05';
};

on 'develop' => sub {
};
