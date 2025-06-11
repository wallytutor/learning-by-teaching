module test_kramers_general
    use constant
    use test_utils
    use ode_rkf45

    !============
    implicit none
    private
    !============

    public test

  contains

    subroutine test()
        call test001()
    end subroutine

    subroutine test001()
        print *, 'TEST: check template'
    end subroutine

end module test_kramers_general

module test_kramers
    use test_kramers_general, only: run_test_kramers_general => test

    !============
    implicit none
    private
    !============

    public test

  contains

    subroutine test()
        print *, ''
        print *, 'test_kramers'

        call run_test_kramers_general()
    end subroutine
    
end module test_kramers
