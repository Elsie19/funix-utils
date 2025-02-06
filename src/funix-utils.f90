module funix_utils
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, funix-utils!"
  end subroutine say_hello
end module funix_utils
