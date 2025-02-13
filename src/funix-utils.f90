!> Module containing many useful components relating to builtin utils.
module funix_utils
    implicit none
    private

    public :: say_hello, cstr_to_fortran_string

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

    !> Convert C-strings to an allocatable fortran string.
    function cstr_to_fortran_string(cstr) result(fstr)
        use iso_c_binding, only: c_char, c_null_char
        implicit none
        character(kind=c_char, len=*), intent(in) :: cstr
        character(len=:), allocatable :: fstr
        integer :: null_pos = 1

        ! Find the position of the null terminator
        do while (null_pos <= len(cstr))
            if (cstr(null_pos:null_pos) == c_null_char) exit
            null_pos = null_pos + 1
        end do

        ! Allocate the Fortran string based on the detected length
        allocate(character(len=null_pos - 1) :: fstr)

        ! Copy up to the null terminator
        fstr = cstr(1:null_pos - 1)
    end function cstr_to_fortran_string
end module funix_utils
