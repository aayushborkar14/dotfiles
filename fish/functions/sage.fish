function sage
    eval "$(~/miniforge3/bin/conda shell.fish hook)"
    conda activate sage
    command sage $argv
    conda deactivate
    conda deactivate
end
