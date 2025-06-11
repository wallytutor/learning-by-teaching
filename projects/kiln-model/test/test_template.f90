module test_some_submodule
    use constant
    use test_utils

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

end module test_some_submodule

module test_template
    use test_some_submodule, only: run_test_some_submodule => test

    !============
    implicit none
    private
    !============

    public test

  contains

    subroutine test()
        print *, ''
        print *, 'test_template'

        call run_test_some_submodule()
    end subroutine
    
end module test_template