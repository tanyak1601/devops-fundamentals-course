#!/usr/bin/env bash

usersdb_path="module_4/task_2/data/users.db"

check_file_fn() {
    if ! [ -f "$usersdb_path" ]
    then
        read -r -p "users.db file does not exist. Create? (y/n): " create_file

        if [ "$create_file" == 'y' ]
        then
            touch ${usersdb_path}
        else
            echo "user.db file does not exist. You must create a file to continue"
            exit 0
        fi
    fi
}

add_fn() {
    check_file_fn
    read -r -p "Enter Username: " username
    read -r -p "enter Role: " role
    
    if [ -z "${username}" ] || [ -z "${role}" ]
    then 
        echo "Input cannot be blank"
        exit 0
    fi

    if ! [[ "$username" =~ ^[A-Za-z]+$ ]] || ! [[ "$role" =~ ^[A-Za-z]+$ ]]
    then
        echo "Username and Role should contain Latin letters only."
        exit 0
    fi

    echo "${username}, ${role}" >> "${usersdb_path}"
    echo "New record '${username}, ${role}' is saved in users.db"
}

help_fn() {
    check_file_fn
    echo "Avaliable commands: 
        add - Add new db record
        backup - Create backup of users.db file
        restore - Takes the last created backup file and replaces users.db with it
        find - Search for users in user.db
        list - Prints the content of the users.db"
}

backup_fn() {
    check_file_fn
    backup_file_path="module_4/task_2/data/$(date +%Y-%m-%d)-users.db.backup"
    cp $usersdb_path "$backup_file_path"
    echo "File '$(date +%Y-%m-%d)-users.db.backup' is created"
}

restore_fn() {
   check_file_fn
   latest_backup_file_path=$(find ./module_4/task_2/data -type f -name "*users.db.backup" | sort -r | head -1)

    if [ -z "${latest_backup_file_path}" ]
    then 
        echo "No backup file found"
        exit 0
    fi

    cat "$latest_backup_file_path" > $usersdb_path

    echo "Latest backup file ${latest_backup_file_path##*/} is restored"
}

find_fn() {
    check_file_fn
    read -r -p "Enter Username: " username

    if [ -z "${username}" ]
    then 
        echo "Input cannot be blank"
        exit 0
    fi

    users=$(grep "^${username}," module_4/task_2/data/users.db)

    if [ -z "${users}" ]
    then 
        echo "User not found"
        exit 0
    fi



    echo "${users}"
}

list_fn() {
    check_file_fn

    if [ "$1" = 1 ]
    then
       nl -w2 -s'. ' ${usersdb_path} | tail -r
    else
        nl -w2 -s'. ' ${usersdb_path}
    fi
}

case "$1" in
    add)
        add_fn
        ;;
    backup)
        backup_fn
        ;;
    restore)
        restore_fn
        ;;
    find)
        find_fn
        ;;
    list)
        if [ "$2" = "--inverse" ]
        then
            list_fn 1
        else
            list_fn
        fi
        ;;
    help)
        help_fn
        ;;
    "")
        check_file_fn
        ;;
    *)
        echo "Uknown command"
        ;;
esac