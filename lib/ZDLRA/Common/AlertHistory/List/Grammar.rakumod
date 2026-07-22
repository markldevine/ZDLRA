unit    grammar ZDLRA::Common::AlertHistory::List::Grammar:api<1>:auth<Mark Devine (mark@markdevine.com)>;

token TOP                   { <log-record>+ }
token log-record            { <log-record-herald> \h+ <first-message-line>
    [
        ^^
        <!before <log-record-herald>>
        <message-line>
    ]*
}
token log-record-herald     { \h* <name> \h+ <datetime> \h+ <severity>                                          }
token first-message-line    { <line-text>                                                                       }
token message-line          { <line-text>                                                                       }
token line-text             { .*? \n                                                                            }
token name                  { \d+ '_' \d+                                                                       }
token severity              { \w+                                                                               }
token datetime              { <year> '-' <month> '-' <day> 'T' <hour> ':' <minute> ':' <second> '-' <offset>    }
token year                  { \d ** 4                                                                           }
token month                 { \d ** 2                                                                           }
token day                   { \d ** 2                                                                           }
token hour                  { \d ** 2                                                                           }
token minute                { \d ** 2                                                                           }
token second                { \d ** 2                                                                           }
token offset                { \d ** 2 ':' \d ** 2                                                               }

=finish
