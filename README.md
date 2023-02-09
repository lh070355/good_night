# Good Night

## Introduction

Implement a "good night" application to let users track when do they go to bed and when do they wake up.

## Requirements

RESTful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

## Environments

```bash
ruby --version # ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]
rails --version # Rails 7.0.4
cat /etc/issue # Ubuntu 18.04.1 LTS
```

- data model
    - reference
        - [ActiveRecord::ConnectionAdapters::SchemaStatements](https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_column)
        - [ActiveRecord::ConnectionAdapters::TableDefinition](https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column)
        - [How To Create a Follow Feature in Rails by Aliasing Associations | by Leizl Samano | Better Programming](https://betterprogramming.pub/how-to-create-a-follow-feature-in-rails-by-aliasing-associations-30d63edee284)
        - [DateAndTime::Calculations](https://api.rubyonrails.org/classes/DateAndTime/Calculations.html)
        - [ActiveRecord::Associations::CollectionProxy](https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/Associations/CollectionProxy.html#method-i-3C-3C)
        - [ActiveRecord::FinderMethods](https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/FinderMethods.html#method-i-last-21)
        - [ActionController::Parameters](https://api.rubyonrails.org/v7.0.4/classes/ActionController/Parameters.html#method-i-permit)
        - [sql - Index for nullable column - Stack Overflow](https://stackoverflow.com/questions/9175591/index-for-nullable-column)
        - [mysql - Index on column with 70% of empty values: Use null or empty value? - Stack Overflow](https://stackoverflow.com/questions/34371494/index-on-column-with-70-of-empty-values-use-null-or-empty-value)
    - associations
        - user has many periods
        - followee (user) has many followers (user) (through relation)
        - follower (user) has many followees (user) (through relation)
    - active records
        - User
            
            
            | id | integer (index) |
            | --- | --- |
            | name | string (non-null) |
            - use `string` over `text` as the column type of the name because it have length limit to 255 characters after being converted to fit the type in some database (e.g. MySQL), and 255 is enough for storing the name
                - [Difference between string and text in rails? - Stack Overflow](https://stackoverflow.com/questions/3354330/difference-between-string-and-text-in-rails)
        - Relation
            
            
            | id | integer (index) |
            | --- | --- |
            | followee_id | integer (index, non-null) |
            | follower_id | integer (index, non-null) |
            - reference
                - [Rails: validate uniqueness of two columns (together) - Stack Overflow](https://stackoverflow.com/questions/34424154/rails-validate-uniqueness-of-two-columns-together)
                    - for uniqueness validation on multiple columns
        - Period
            
            
            | id | integer (index) |
            | --- | --- |
            | user_id | integer (index, non-null) |
            | sleep_time | datetime (index) |
            | wake_up_time | datetime (index) |
            | duration | integer (index, 3 bytes) |
            - reference
                - [mysql - Order by column should have index or not? - Database Administrators Stack Exchange](https://dba.stackexchange.com/questions/11031/order-by-column-should-have-index-or-not)
- APIs
    - put general exception handlers in `ApplicationController` for simplicity
    - only accept the pre-defined parameters for security
    - RelationsController
        - `POST` /relation
            - error condition
                - repeated
                    - `ActiveRecord::RecordInvalid`
                - id not exist
                    - `ActiveRecord::RecordNotFound`
                - wrong parameter type
                    - `ActiveRecord::RecordNotFound`
                - self following
                    - `ActiveRecord::RecordInvalid`
                - paramter missing
                    - `ActionController::ParameterMissing`
        - `DELETE` /relation
            - check
            - error condition
                - paramter missing
                    - `ActionController::ParameterMissing`
    - PeriodsController
        - `POST` /period
            - return error message for each of the following:
                - the wake_up time of the last record is not clock-in and the sleep time of it is within 11 days
        - `PUT` /latest_period
            - return error message for each of the following:
                - there is no record for this person
                - the wake_up time of the last record has already clock-in
                - the time difference of the wake_up time and the sleep time in the last records is more than 11 days
        - `GET` /user/periods
            - reference
                - [DateAndTime::Calculations](https://api.rubyonrails.org/classes/DateAndTime/Calculations.html)