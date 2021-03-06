@super_user @manager_user
Feature:  reconciliation upload


  Scenario Outline: perform reconciliation by RISKMAN (MSW-397)
    Given get userdata row of the MANAGER
     And create url of userdata row and get token
     And define request userdata form
     And make correction of userdata form <field> <amount>
     And make post request to change userdata table
    When by RISKMAN make post request to make reconciliation <podushka> <zp_cash> <account_plus_minus> <cash> <social>
    Then compare result response with expected result <expected_result>
      Examples: cases
        |  field                | amount | podushka   | zp_cash | account_plus_minus| cash | social| expected_result                                            |
        |    none               |   0    |   4000     | 781     |  700              |   30 |   0   |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 781     |  701              |   30 |   1   |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 781     |  700              |   29 |   1   |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 781     |  700              |   30 |   1   |    "ok"                                                    |
        |    none               |   0    |   4001     | 781     |  700              |   30 |   1   |    Podushka greater than 4000 while account < 2000         |
        |    account            |   1999 |   4001     | 781     |  700              |   30 |   1   |    Podushka greater than 4000 while account < 2000         |
        |    account            |   1999 |   4000     | 781     |  700              |   30 |   1   |    "ok"                                                    |
        |    none               |   0    |   4000     | 781     |  -1000            | 1730 |   1   |    "ok"                                                    |
        |    none               |   0    |   4000     | 781     |  -1001            | 1730 |   2   |    Change (+/-) greater than account                       |
        |    account            |   3049 |   6098     | 1       |  -49              |   0  |   0   |    Final multiplied by Payout rate less than Office Fees while Podushka greater than 0 |
        |    account            |   3049 |   6100     | 0       |  -50              |   0  |   0   |    Podushka greater than account * 2 while account >= 2000 |
        |    prev_month_net     |  -1000 |   0        | 0       |  -50              |   0  |   0   |    "ok"                                                    |
        |    prev_month_net     |  -100  |   100      | 0       |  -50              |   0  |   0   |    Podushka is no equal to 0                               |
        |    prev_month_net     |  -1000 |   100      | 0       |  -50              |   0  |   0   |    Podushka is no equal to 0                               |


  Scenario: perform reconciliation
      Given manager check the status of reconciliation: false
       And manager try to perform reconciliation: -Reconciliation is over-
      When superuser activate reconciliation
      Then manager check the status of reconciliation: true

  Scenario Outline: perform reconciliation
    Given get userdata row of the MANAGER
     And create url of userdata row and get token
     And define request userdata form
     And make correction of userdata form <field> <amount>
     And make post request to change userdata table
    When make post request to make reconciliation <podushka> <zp_cash> <account_plus_minus> <cash> <social>
    Then compare result response with expected result <expected_result>
      Examples: cases
        |  field                | amount | podushka   | zp_cash | account_plus_minus| cash | social| expected_result                                            |
        |    none               |   0    |   4000     | 781     |  700              |   30 |   0   |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 781     |  701              |   30 |   1   |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 781     |  700              |   29 |   1   |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 781     |  700              |   30 |   1   |    "ok"                                                    |
        |    none               |   0    |   4001     | 781     |  700              |   30 |   1   |    Podushka greater than 4000 while account < 2000         |
        |    account            |   1999 |   4001     | 781     |  700              |   30 |   1   |    Podushka greater than 4000 while account < 2000         |
        |    account            |   1999 |   4000     | 781     |  700              |   30 |   1   |    "ok"                                                    |
        |    none               |   0    |   4000     | 781     |  -1000            | 1730 |   1   |    "ok"                                                    |
        |    none               |   0    |   4000     | 781     |  -1001            | 1730 |   2   |    Change (+/-) greater than account                       |
        |    account            |   3049 |   6098     | 1       |  -49              |   0  |   0   |    Final multiplied by Payout rate less than Office Fees while Podushka greater than 0 |
        |    account            |   3049 |   6100     | 0       |  -50              |   0  |   0   |    Podushka greater than account * 2 while account >= 2000 |
        |    prev_month_net     |  -1000 |   0        | 0       |  -50              |   0  |   0   |    "ok"                                                    |
        |    prev_month_net     |  -100  |   100      | 0       |  -50              |   0  |   0   |    Podushka is no equal to 0                               |
        |    prev_month_net     |  -1000 |   100      | 0       |  -50              |   0  |   0   |    Podushka is no equal to 0                               |


   Scenario Outline: make questions
      Given create template for <type_question> question
       And make post request to make question
       And pause - 7 sec(s)
      Then check that question comes to telegram_bot <telegram_bot>
       But cancel ticket in telegram_bot <telegram_bot>
      Examples: cases
     | type_question        | telegram_bot  |
     |service_undefined     | sd_test3_bot  |
     |compensation_undefined| sd_test8_bot  |
     |fee_undefined         | sd_test3_bot  |



     Scenario: create feedback
      Given create template for feedback
       And make post request to create feedback
       And pause - 7 sec(s)
      Then check that feedback comes to telegram_bot sd_test3_bot
       But cancel ticket in telegram_bot sd_test3_bot

    Scenario Outline: perform reconciliation
    Given get userdata row of the MANAGER
     And create url of userdata row and get token
     And define request userdata form
     And make correction of userdata form <field> <amount>
     And make post request to change userdata table
     And change field -custom_payout_rate- in UserData table of user with hr_id 234275 to 0.66
    When make post request to make reconciliation <podushka> <zp_cash> <account_plus_minus> <cash> <social>
    Then compare result response with expected result <expected_result>
      Examples: cases
        |  field                | amount | podushka   | zp_cash  | account_plus_minus| cash | social| expected_result                                            |
        |    none               |   0    |   4000     | 1386     |  300              | 1000 |   35  |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 1386     |  301              | 1000 |   36  |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 1386     |  300              | 1001 |   36  |    Change (+/-) + Withdrawal + Social not equal to Total   |
        |    none               |   0    |   4000     | 1386     |  300              | 1000 |   36  |    "ok"                                                    |
        |    none               |   0    |   4001     | 1386     |  300              | 1000 |   36  |    Podushka greater than 4000 while account < 2000         |
        |    account            |  1999  |   4001     | 1386     |  300              | 1000 |   36  |    Podushka greater than 4000 while account < 2000         |
        |    account            |  1999  |   4000     | 1386     |  300              | 1000 |   36  |    "ok"                                                    |
        |    none               |   0    |   4000     | 1386     |  -1000            | 2300 |   36  |    "ok"                                                    |
        |    none               |   0    |   4000     | 1386     |  -1001            | 2300 |   37  |    Change (+/-) greater than account                       |
        |    account            |   3049 |   6098     | 1        |  -49              |   0  |   0   |    Final multiplied by Payout rate less than Office Fees while Podushka greater than 0 |
        |    account            |   3049 |   6100     | 0        |  -50              |   0  |   0   |    Podushka greater than account * 2 while account >= 2000 |
        |    prev_month_net     |  -1000 |   0        | 0        |  -50              |   0  |   0   |    "ok"                                                    |
        |    prev_month_net     |  -100  |   100      | 0        |  -50              |   0  |   0   |    Podushka is no equal to 0                               |
        |    prev_month_net     |  -1000 |   100      | 0        |  -50              |   0  |   0   |    Podushka is no equal to 0                               |

