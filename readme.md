# Shell Script - Install and Setting MongoDB

## init.sh

- line 38: "user: 'root'" change to whatever you want
- line 38: "pwd: '123'" change to whatever you want
- line 49: instead of "root" inform the user of the password creation
- line 49: instead of the "pass" enter the previous password
- line 50: enter the bank name instead of the "app"
- line 51: "user: 'external_user'" change to whatever you want
- line 51: "pwd: '123'" change to whatever you want
- line 51: "db: 'app'" enter the name of the bank created earlier

## INIT INSTALL

- chmod 777 init.sh
- ./init.sh
