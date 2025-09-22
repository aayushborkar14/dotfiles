function load_intel_env
    # List of read-only or special variables in Fish
    set -l readonly_vars PWD SHLVL _ status fish_pid pipestatus

    bash -c 'source /opt/intel/oneapi/setvars.sh intel64 && env' | while read -l line
        if string match -q "*=*" -- $line
            set -l key (string split -m1 "=" $line)[1]
            set -l val (string split -m1 "=" $line)[2]
            # Skip invalid or readonly keys
            if string match -rq '^[a-zA-Z_][a-zA-Z0-9_]*$' -- $key
                if not contains $key $readonly_vars
                    set -gx $key $val
                end
            end
        end
    end
end
