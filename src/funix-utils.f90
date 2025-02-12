!> Module containing many useful components relating to builtin utils.
module funix_utils
    implicit none
    private

    public :: say_hello

    public EX_OK, EX_BAD, EX_MISUSE

    !> Ok exit code.
    integer, parameter :: EX_OK = 0
    !> Bad exit code.
    integer, parameter :: EX_BAD = 1
    !> Builtin misuse exit code.
    integer, parameter :: EX_MISUSE = 2
contains
    subroutine say_hello
        print *, "Hello, funix-utils!"
    end subroutine say_hello
end module funix_utils
