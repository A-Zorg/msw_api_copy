@manager_user
Feature: no permission


  Scenario Outline: check manager permissions
    Then manager makes request: <url> , result: <code>
    Examples: urls
        |  url                                  | code |
        |  /accounting_system/bills/company/    | 403  |
        |  /accounting_system/bills/user/types/ | 403  |
        |  /accounting_system/bills/user/1/     | 403  |
        |  /accounting_system/bills/users/      | 403  |
        |  /accounting_system/entries/          | 403  |
        |  /accounting_system/entry/            | 403  |
        |  /accounting_system/report_fields/    | 403  |
        |  /accounting_system/report/           | 403  |