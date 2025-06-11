program check
    use test_template,  only: run_test_template  => test
    use test_numerical, only: run_test_numerical => test
    use test_thermo,    only: run_test_thermo    => test
    use test_kramers,   only: run_test_kramers   => test

    !============
    implicit none
    !============

    print *, 'STARTING TESTS'

    call run_test_template()
    call run_test_numerical()
    call run_test_thermo()
    call run_test_kramers()

end program check
