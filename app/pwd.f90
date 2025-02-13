program pwd
    use iso_c_binding, only: c_char, c_ptr, c_null_ptr, c_null_char, c_associated
    use realpath_interface, only: realpath
    use flap, only: command_line_interface
    use funix_utils, only: cstr_to_fortran_string

    implicit none

    type(command_line_interface) :: cli
    integer :: error
    logical :: physical
    character(len=255) :: cwd
    character(kind=c_char, len=256) :: realpath_dir
    character(kind=c_char, len=256) :: resolved_name
    type(c_ptr) :: result_ptr

    call cli%init(progname='pwd', &
        version='0.0.1',          &
        authors='Elsie',          &
        license='GPLv2',          &
        description='print name of current/working directory')
    call cli%add(switch='--physical',     &
        switch_ab='-P',                   &
        help='print fully resolved name', &
        required=.false.,                 &
        act='store_true',                 &
        def='.false.',                    &
        error=error)
    call cli%get(switch='-P', val=physical, error=error) ; if (error /= 0) stop
    call cli%free()

    call getcwd(cwd)

    if (physical) then
        realpath_dir = trim(cwd) // c_null_char
        result_ptr = realpath(trim(realpath_dir), resolved_name)
        if (c_associated(result_ptr)) then
            print '(a)', cstr_to_fortran_string(resolved_name)
        else
            error stop "Could not resolve path"
        end if
    else
        print '(a)', trim(cwd)
    end if

end program pwd

module realpath_interface
    implicit none

    interface
        function realpath(file_name, resolved_name) bind(C, name='realpath')
            use iso_c_binding, only: c_ptr, c_char
            implicit none
            type(c_ptr) :: realpath
            character(kind=c_char), intent(in) :: file_name(*)
            character(kind=c_char), intent(out) :: resolved_name(*)
        end function realpath
    end interface
end module realpath_interface
