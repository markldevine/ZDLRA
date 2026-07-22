unit    class ZDLRA::Common::AlertHistory::List::Actions:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use     ZDLRA::Common::AlertHistory::List::Record;

method TOP ($/)                 { make $<log-record>».made.Array;                                                       }
method log-record-herald ($/)   { make { name     => ~$<name>, datetime => ~$<datetime>, severity => ~$<severity>, };   }

method log-record ($/)          {
    my %herald = $<log-record-herald>.made;
    my @message = $<first-message-line>.Str, |($<message-line>».Str);
    make ZDLRA::Common::AlertHistory::List::Record.new(|%herald, message => @message);
}


=finish
