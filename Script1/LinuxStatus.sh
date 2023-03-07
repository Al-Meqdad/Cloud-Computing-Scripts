#!/bin/env bash


function welcome_screen(){
	echo "Welcome to LinuxStatus"
	echo "Todays Date is $(date)"
	echo "Hello and Welcome $(whoami)"
	echo "You are running Ubuntu Version $(uname -r)"
	echo "Select an option:"
	echo "1 List all the running proccess"
	echo "2 Check Memory Status"
	echo "3 Check HardDisk Status"
	echo "4 Check apache version"
	echo "5 exit"
}

function running_proccess(){
	function_name=running_proccess
	ps aux
	options_menu
	handle_options_menu_input
}

function memory_status(){
	function_name=memory_status
	free -h
	options_menu
	handle_options_menu_input
}

function hdd_status(){
	function_name=hdd_status
	df -h
	options_menu
	handle_options_menu_input
}

function check_apache() {
	function_name=check_apache
	echo "Your Apache version is: $(apache2 -v | grep 'version')"
	options_menu
	handle_options_menu_input
}

function options_menu(){
	echo "Select an option:"
	echo "1 Back to Main Menu"
	echo "2 Update View"
	echo "3 Exit"
}

function handle_options_menu_input() {
    read -p "Enter your choice: " menu_choice
    case ${menu_choice} in
        1)
            # Back to Main Menu
	    clear
            welcome_screen
            ;;
        2)
            # Update View
            clear
            $function_name
            ;;
        3)
            # Exit
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 3."
            handle_options_menu_input
            ;;
    esac
}


welcome_screen

while true; do
	read -p "Enter Your Choice: " opt
	case ${opt} in
		p|1)
			clear
			running_proccess
			;;
		r|2)
			clear
			memory_status
			;;
		h|3)
			clear
			hdd_status
			;;
		a|4)
			clear
			check_apache
			;;
		5)
			clear
			exit 0
			;;
		\? )
			echo "Invalid option -$OPTARG" 1>&2
			exit 1
			;;
		: )
			echo "Option -$OPTARG requires an argument." 1>&2
			exit 1
			;;
	esac
done

#END
