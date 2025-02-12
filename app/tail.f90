program tail
    use funix_utils, only: EX_BAD
    use flap, only: command_line_interface
    use iso_fortran_env, only: error_unit

    implicit none

    type(command_line_interface) :: cli
    integer :: unit, ios, lines, line_count = 0, n_lines_to_read = 0, i, start_index
    logical :: file_exists
    integer :: error
    character(len=100) :: file
    character(len=255) :: line
    character(len=255), allocatable :: lines_array(:)

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

    inquire(file=file, exist=file_exists)
    if (.not. file_exists) then
        write (error_unit, '(a)'), cli%progname // ": cannot open " // "'" // trim(file) // "'" // " for reading: No such file or directory"
        call exit(EX_BAD)
    end if

    call cli%free()

    open(unit=unit, file=file, status='old')

    line_count = 0
    do while (.true.)
        read(unit, '(A)', iostat=ios) line
        if (ios /= 0) exit
        line_count = line_count + 1
    end do

    allocate(lines_array(line_count))

    rewind(unit)
    line_count = 0
    do while (.true.)
        read(unit, '(A)', iostat=ios) line
        if (ios /= 0) exit
        line_count = line_count + 1
        lines_array(line_count) = trim(adjustl(line))
    end do

    close(unit)

    n_lines_to_read = 0
    start_index = max(1, line_count - lines + 1)
    do i = start_index, line_count
        print '(A)', trim(adjustl(lines_array(i)))
        n_lines_to_read = n_lines_to_read + 1
        if (n_lines_to_read == lines) exit
    end do

end program tail
