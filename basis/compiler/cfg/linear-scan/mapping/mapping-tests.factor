USING: compiler.cfg.instructions
compiler.cfg.linear-scan.allocation.state
compiler.cfg.linear-scan.mapping cpu.architecture kernel
namespaces tools.test ;
IN: compiler.cfg.linear-scan.mapping.tests

H{ { int-regs 10 } { float-regs 20 } } clone spill-counts set
init-mapping

[
    {
        T{ _copy { dst 5 } { src 4 } { class int-regs } }
        T{ _spill { src 1 } { class int-regs } { n 10 } }
        T{ _copy { dst 1 } { src 0 } { class int-regs } }
        T{ _reload { dst 0 } { class int-regs } { n 10 } }
        T{ _spill { src 1 } { class float-regs } { n 20 } }
        T{ _copy { dst 1 } { src 0 } { class float-regs } }
        T{ _reload { dst 0 } { class float-regs } { n 20 } }
    }
] [
    {
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
        T{ register->register { from 1 } { to 0 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 1 } { reg-class float-regs } }
        T{ register->register { from 1 } { to 0 } { reg-class float-regs } }
        T{ register->register { from 4 } { to 5 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    {
        T{ _spill { src 2 } { class int-regs } { n 10 } }
        T{ _copy { dst 2 } { src 1 } { class int-regs } }
        T{ _copy { dst 1 } { src 0 } { class int-regs } }
        T{ _reload { dst 0 } { class int-regs } { n 10 } }
    }
] [
    {
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
        T{ register->register { from 1 } { to 2 } { reg-class int-regs } }
        T{ register->register { from 2 } { to 0 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    {
        T{ _spill { src 0 } { class int-regs } { n 10 } }
        T{ _copy { dst 0 } { src 2 } { class int-regs } }
        T{ _copy { dst 2 } { src 1 } { class int-regs } }
        T{ _reload { dst 1 } { class int-regs } { n 10 } }
    }
] [
    {
        T{ register->register { from 1 } { to 2 } { reg-class int-regs } }
        T{ register->register { from 2 } { to 0 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    {
        T{ _copy { dst 1 } { src 0 } { class int-regs } }
        T{ _copy { dst 2 } { src 0 } { class int-regs } }
    }
] [
    {
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 2 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    { }
] [
    {
       T{ register->register { from 4 } { to 4 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    {
        T{ _spill { src 3 } { class int-regs } { n 4 } }
        T{ _reload { dst 2 } { class int-regs } { n 1 } } 
    }
] [
    {
        T{ register->memory { from 3 } { to T{ spill-slot f 4 } } { reg-class int-regs } }
        T{ memory->register { from T{ spill-slot f 1 } } { to 2 } { reg-class int-regs } }
    } mapping-instructions
] unit-test


[
    {
        T{ _copy { dst 1 } { src 0 } { class int-regs } }
        T{ _copy { dst 2 } { src 0 } { class int-regs } }
        T{ _copy { dst 0 } { src 3 } { class int-regs } }
    }
] [
    {
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
        T{ register->register { from 3 } { to 0 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 2 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    {
        T{ _copy { dst 1 } { src 0 } { class int-regs } }
        T{ _copy { dst 2 } { src 0 } { class int-regs } }
        T{ _spill { src 4 } { class int-regs } { n 10 } }
        T{ _copy { dst 4 } { src 0 } { class int-regs } }
        T{ _copy { dst 0 } { src 3 } { class int-regs } }
        T{ _reload { dst 3 } { class int-regs } { n 10 } }
    }
] [
    {
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 2 } { reg-class int-regs } }
        T{ register->register { from 3 } { to 0 } { reg-class int-regs } }
        T{ register->register { from 4 } { to 3 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 4 } { reg-class int-regs } }
    } mapping-instructions
] unit-test

[
    {
        T{ _copy { dst 2 } { src 0 } { class int-regs } }
        T{ _copy { dst 9 } { src 1 } { class int-regs } }
        T{ _copy { dst 1 } { src 0 } { class int-regs } }
        T{ _spill { src 4 } { class int-regs } { n 10 } }
        T{ _copy { dst 4 } { src 0 } { class int-regs } }
        T{ _copy { dst 0 } { src 3 } { class int-regs } }
        T{ _reload { dst 3 } { class int-regs } { n 10 } }
    }
] [
    {
        T{ register->register { from 0 } { to 1 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 2 } { reg-class int-regs } }
        T{ register->register { from 1 } { to 9 } { reg-class int-regs } }
        T{ register->register { from 3 } { to 0 } { reg-class int-regs } }
        T{ register->register { from 4 } { to 3 } { reg-class int-regs } }
        T{ register->register { from 0 } { to 4 } { reg-class int-regs } }
    } mapping-instructions
] unit-test
