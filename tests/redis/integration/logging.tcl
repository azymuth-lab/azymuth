tags {"external:skip"} {

set system_name [string tolower [exec uname -s]]
set backtrace_supported 0

# We only support darwin or Linux with glibc
if {$system_name eq {darwin}} {
    set backtrace_supported 1
} elseif {$system_name eq {linux}} {
    # Avoid the test on libmusl, which does not support backtrace
    set ldd [exec ldd src/redis-server]
    if {![string match {*libc.musl*} $ldd]} {
        set backtrace_supported 1
    }
}

if {$backtrace_supported} {
    set server_path [tmpdir server.log]
    start_server [list overrides [list dir $server_path]] {
        test "Server is able to generate a stack trace on selected systems" {
            r config set watchdog-period 200
            r debug sleep 1
            set pattern "*debugCommand*"
            set retry 10
            while {$retry} {
                set result [exec tail -100 < [srv 0 stdout]]
                if {[string match $pattern $result]} {
                    break
                }
                incr retry -1
                after 1000
            }
            if {$retry == 0} {
                error "assertion:expected stack trace not found into log file"
            }
        }
    }
}

# Valgrind will complain that the process terminated by a signal, skip it.
if {!$::valgrind} {
    if {$backtrace_supported} {
        set crash_pattern "*STACK TRACE*"
    } else {
        set crash_pattern "*crashed by signal*"
    }

    set server_path [tmpdir server1.log]
    start_server [list overrides [list dir $server_path]] {
        test "Crash report generated on SIGABRT" {
            set pid [s process_id]
            exec kill -SIGABRT $pid
            set result [exec tail -1000 < [srv 0 stdout]]
            assert {[string match $crash_pattern $result]}
        }
    }

    set server_path [tmpdir server2.log]
    start_server [list overrides [list dir $server_path]] {
        test "Crash report generated on DEBUG SEGFAULT" {
            catch {r debug segfault}
            set result [exec tail -1000 < [srv 0 stdout]]
            assert {[string match $crash_pattern $result]}
        }
    }
}

}
