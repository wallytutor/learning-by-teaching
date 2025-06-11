program check
    use test_template,  only: run_test_template  => test
    use test_thermo,    only: run_test_thermo    => test
    use test_numerical, only: run_test_numerical => test

    !============
    implicit none
    !============

    print *, 'STARTING TESTS'

    call run_test_template()
    call run_test_thermo()
    call run_test_numerical()
    call testdev()

contains

    subroutine testdev()
    end subroutine

end program check
