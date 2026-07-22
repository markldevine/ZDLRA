unit    class ZDLRA::Common::AlertHistory::List::Record:api<1>:auth<Mark Devine (mark@markdevine.com)>;

has     $.name                  is required;
has     $.datetime              is required;
has     $.severity              is required;
has     @.message               is required;

=finish
