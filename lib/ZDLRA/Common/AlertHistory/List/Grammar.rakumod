unit    grammar ZDLRA::Common::AlertHistory::List::Grammar:api<1>:auth<Mark Devine (mark@markdevine.com)>;

token TOP                       {   <detail-record>+                                        }
token detail-record             {
                                    <name-line>                 # 252:0
                                    <physicalInsertTime-line>   # 2026-04-09T04:00:58-04:00
                                    \n*
                                }
token name-line                 { ^^ \s+ 'name:' \s+ <name>                              \n }
token name                      { \d+ ':' \d+                                               }
token physicalInsertTime-line   {
                                    ^^ \s+ 'physicalInsertTime:' \s+
                                    <year>
                                    '-'
                                    <month>
                                    '-'
                                    <day>
                                    'T'
                                    <hour>
                                    ':'
                                    <minute>
                                    ':'
                                    <second>
                                    '-'
                                    <offset>
                                    \n
                                }
token year                      { \d\d\d\d                                                  }
token month                     { \d\d                                                      }
token day                       { \d\d                                                      }
token hour                      { \d\d                                                      }
token minute                    { \d\d                                                      }
token second                    { \d\d                                                      }
token offset                    { \d\d ':' \d\d                                             }

=finish

my grammar ALERTHISTORY-GRAMMAR {
    token TOP                   { <log-record>+                                                             }
    token log-record            { <log-record-start> || <log-record-continue>                               }
    token log-record-start      { ^^ <log-record-herald> \s+ <log-text>                                     }
    token log-record-herald     { \s* <name> \s+ <datetime> \s+ <severity>                                  }
    token log-record-continue   { ^^ <!before <log-record-herald>> <log-text>                               }
    token name                  { \d+ '_' \d+                                                               }
    token datetime              { \d\d\d\d '-' \d\d '-' \d\d 'T' \d\d ':' \d\d ':' \d\d '-' \d\d ':' \d\d   }
    token severity              { \w+                                                                       }
    token log-text              { .+? \n                                                                    }
}
