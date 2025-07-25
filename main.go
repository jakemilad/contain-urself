package main

import (
	"fmt"
	"os"
	"os/exec"
	"syscall"

	"golang.org/x/sys/unix"
)

func main() {
	fmt.Println("Program Name: Contain Yourself")
	if len(os.Args) > 1 {
		var arg = os.Args[1]
		if arg == "run" {
			runContainer()
		} else if arg == "help" {
			helpUser()
		} else {
			fmt.Println("Not running or helping...")
		}
	} else {
		helpUser()
	}
}

func helpUser() {
	fmt.Println("Usage: mycontainer <command> [options]")
	fmt.Println("Commands:")
	fmt.Println("run - Run a container")
	fmt.Println("help - Show this help message")
}

func runContainer() {
	fmt.Println("Running container...")
	if len(os.Args) > 2 {
		programToRun := os.Args[2]
		fmt.Println("you want to run: ", programToRun)
		runApplication(programToRun)
	} else {
		fmt.Println("Error: No program to run")
		fmt.Println("Usage: mycontainer run <program>")
		fmt.Println("Example: mycontainer run /bin/sh")
		fmt.Println("Example: go run main.go run /bin/echo hello")
	}
}

func runApplication(programToRun string) {
	programArgs := os.Args[3:]
	fmt.Println("with args: ", programArgs)

	containerRoot := "/tmp/mycontainer-root"

	fmt.Println("Starting container with auto-mounted filesystems...")
	allArgs := append([]string{programToRun}, programArgs...)
	cmd := exec.Command("/bin/container-init", allArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	cmd.SysProcAttr = &syscall.SysProcAttr{
		Cloneflags: unix.CLONE_NEWPID | unix.CLONE_NEWNS | unix.CLONE_NEWNET,
		Chroot:     containerRoot,
	}

	err := cmd.Run()
	if err != nil {
		fmt.Println("Error: ", err)
	}
}
