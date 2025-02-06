program tail
    use flap, only: command_line_interface
    use iso_fortran_env, only: output_unit

    implicit none

    type(command_line_interface) :: cli
    integer :: lines
    integer :: count
    integer :: error
    character(len=90) :: file

    call cli%init(progname='tail',      &
        version='0.0.1',                &
        authors='Elsie',                &
        license='GPLv2',                &
        description='output the last part of files')
    call cli%add(switch='--lines',        &
        switch_ab='-n',                   &
        help='output the last NUM lines', &
        required=.false.,                 &
        act='store',                      &
        def='10',                         &
        error=error)
    call cli%add(positional=.true., position=1, help='file', required=.true., act='store')
    if (error /= 0) stop
    call cli%get(switch='-n', val=lines, error=error) ; if (error /= 0) stop
    call cli%get(position=1, val=file, error=error) ; if (error /= 0) stop
    print '(A)', cli%progname // ' has been called with the following argument:'
    call cli%free()
    write(output_unit, '(a, i0)') "Lines = ", lines
    write(output_unit, '(a, a)') "File = ", file

    count = command_argument_count()
    print *, count
end program tail
