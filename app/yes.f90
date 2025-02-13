program yes
    use flap, only: command_line_interface

    implicit none

    type(command_line_interface) :: cli
    integer :: error
    character(len=100) :: to_print

    call cli%init(progname='yes', &
        version='0.0.1',          &
        authors='Elsie',          &
        license='GPLv2',          &
        description='print a string until interrupted')
    call cli%add(positional=.true., position=1, help='string', required=.false., def='y', error=error) ; if (error /= 0) stop
    call cli%get(position=1, val=to_print, error=error) ; if (error /= 0) stop
    call cli%free()

    do
        print '(a)', trim(to_print)
    end do

end program yes
