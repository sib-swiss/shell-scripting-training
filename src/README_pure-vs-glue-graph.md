  The figures for the "pure vs. glue" slides were obtained by running
  `pure_vs_glue.sh` and averaging with `mlr`:

  ```bash
  $ ./pure_vs_glue.sh 10 100 200 500 1000 | mlr --ofmt '%.4f' stats1 -a mean -f pure,glue -g lines > mid_avg.dkvp
  $ ./pure_vs_glue.sh 50 1 2 3 4 5 10 20  | mlr --ofmt '%.4f' stats1 -a mean -f pure,glue -g lines > small_avg.dkvp
  $ ./pure_vs_glue.sh 3 2000 5000 10000   | mlr --ofmt '%.4f' stats1 -a mean -f pure,glue -g lines > large_avg.dkvp
  ```

  Then the data (some after concatenation) were converted back to CSV with `mlr`
  (the files were kept in DKVP instead of TSV to facilitate concatenation) and
  then graphed with Julia.
