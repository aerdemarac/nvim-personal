# ---------------------------------------------------------
# 1. UI & READABILITY
# ---------------------------------------------------------
set disassembly-flavor intel
set print pretty on
set print array on
set print address on
set print demangle on
set confirm off

winheight cmd +10
lay src

# Improves the display of long backtraces
set backtrace limit 20

# ---------------------------------------------------------
# 2. AUTOMATION
# ---------------------------------------------------------
# Automatically start the program when GDB is launched
# define r
#   run
# end

# Catch exceptions/signals immediately
handle SIGALRM ignore
handle SIGPIPE noignore
handle SIGUSR1 noprint

# ---------------------------------------------------------
# 3. CUSTOM C UTILS
# ---------------------------------------------------------

# Dump memory at an address (size and format)
define dump_mem
    printf "Dumping %d units of memory at %p:\n", $arg1, $arg0
    x/$arg1$arg2 $arg0
end
document dump_mem
    Usage: dump_mem [address] [count] [format]
    Example: dump_mem buf 16 x (Dumps 16 hex bytes)
end

# Check for NULL and print a clear error
define check_null
    if $arg0 == 0
        printf "Variable %s is NULL\n", "$arg0"
    else
        print $arg0
    end
end

# ---------------------------------------------------------
# 4. DASHBOARD (Optional but Recommended)
# ---------------------------------------------------------
# If you want a visual "IDE-like" layout without installing tools, 
# use the built-in TUI mode.
# Usage: press Ctrl+X then Ctrl+A during a session.
set tui border-kind ascii
set disassembly-flavor intel
set environment LSAN_OPTIONS detect_leaks=0
